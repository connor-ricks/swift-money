import Foundation
@testable import Money
import Testing

@Suite
struct MoneyFormatStyleTests {

    // MARK: - Parity Tests (default scale, en-US)

    @Test
    func usd_formatted_enUS() {
        let locale = Locale(identifier: "en-US")
        #expect(Money(amount: -12_250.25, currency: .USD).formatted(.money(locale: locale)) == "-$12,250.25")
        #expect(Money(amount: -19.25, currency: .USD).formatted(.money(locale: locale)) == "-$19.25")
        #expect(Money(amount: -19, currency: .USD).formatted(.money(locale: locale)) == "-$19.00")
        #expect(Money(amount: 0, currency: .USD).formatted(.money(locale: locale)) == "$0.00")
        #expect(Money(amount: 19, currency: .USD).formatted(.money(locale: locale)) == "$19.00")
        #expect(Money(amount: 19.25, currency: .USD).formatted(.money(locale: locale)) == "$19.25")
        #expect(Money(amount: 12_250.25, currency: .USD).formatted(.money(locale: locale)) == "$12,250.25")
    }

    // MARK: - Default Scale Uses Currency Minor Units

    @Test
    func formatted_defaultScale_usesMinorUnits() {
        let enUS = Locale(identifier: "en-US")
        // USD: minorUnits == 2 → two fraction digits
        #expect(Money(amount: 19, currency: .USD).formatted(.money(locale: enUS)) == "$19.00")
        // JPY: minorUnits == 0 → no fraction digits
        #expect(Money(amount: 19, currency: .JPY).formatted(.money(locale: enUS)) == "¥19")
    }

    // MARK: - Custom Scale (regression guard for dropped .precision fix)

    @Test
    func formatted_customScale_honorsFractionLength() {
        let enUS = Locale(identifier: "en-US")
        // scale: 0 → round to whole dollar, display no cents
        #expect(Money(amount: 19.99, currency: .USD).formatted(.money(locale: enUS, scale: 0)) == "$20")
        // scale: 3 → three fraction digits
        #expect(Money(amount: 19.125, currency: .USD).formatted(.money(locale: enUS, scale: 3)) == "$19.125")
        // scale: 4 → bankers rounding at 4th digit
        #expect(Money(amount: 19.12345, currency: .USD).formatted(.money(locale: enUS, scale: 4)) == "$19.1234")
    }

    // MARK: - Notation

    @Test
    func formatted_notation_compactName() {
        let enUS = Locale(identifier: "en-US")
        // Fraction length from currency minor units (2) is preserved in compact notation.
        #expect(Money(amount: 12_500, currency: .USD).formatted(.money(locale: enUS, notation: .compactName)) == "$12.50K")
        #expect(Money(amount: 1_234_567, currency: .USD).formatted(.money(locale: enUS, notation: .compactName)) == "$1.23M")
        // With scale: 0, no fraction digits are shown.
        #expect(Money(amount: 12_500, currency: .USD).formatted(.money(locale: enUS, scale: 0, notation: .compactName)) == "$12K")
    }

    // MARK: - Sign Strategies

    @Test
    func formatted_sign_always() {
        let enUS = Locale(identifier: "en-US")
        #expect(Money(amount: 19, currency: .USD).formatted(.money(locale: enUS, sign: .always())) == "+$19.00")
        #expect(Money(amount: -19, currency: .USD).formatted(.money(locale: enUS, sign: .always())) == "-$19.00")
    }

    @Test
    func formatted_sign_never() {
        let enUS = Locale(identifier: "en-US")
        #expect(Money(amount: -19, currency: .USD).formatted(.money(locale: enUS, sign: .never)) == "$19.00")
    }

    @Test
    func formatted_sign_automatic() {
        let enUS = Locale(identifier: "en-US")
        #expect(Money(amount: -19, currency: .USD).formatted(.money(locale: enUS, sign: .automatic)) == "-$19.00")
        #expect(Money(amount: 19, currency: .USD).formatted(.money(locale: enUS, sign: .automatic)) == "$19.00")
    }

    // MARK: - Rounding Modes

    @Test
    func formatted_roundingModes() {
        let enUS = Locale(identifier: "en-US")
        // .bankers rounds 19.125 to 19.12 (round half to even)
        #expect(Money(amount: 19.125, currency: .USD).formatted(.money(locale: enUS, rounding: .bankers)) == "$19.12")
        // .up rounds 19.125 to 19.13
        #expect(Money(amount: 19.125, currency: .USD).formatted(.money(locale: enUS, rounding: .up)) == "$19.13")
        // .down truncates 19.129 to 19.12
        #expect(Money(amount: 19.129, currency: .USD).formatted(.money(locale: enUS, rounding: .down)) == "$19.12")
    }

    // MARK: - Fluent Modifiers

    @Test
    func formatStyle_fluentModifiers() {
        let enUS = Locale(identifier: "en-US")
        let style = Money.FormatStyle()
            .locale(enUS)
            .scale(0)
            .sign(strategy: .always())
            .notation(.automatic)
            .rounding(.up)

        #expect(style.locale == enUS)
        #expect(style.scale == 0)
        #expect(style.rounding == .up)

        // End-to-end: scale 0, always-positive sign, round up
        #expect(Money(amount: 19.01, currency: .USD).formatted(style) == "+$20")
    }

    // MARK: - Codable Round-Trip

    @Test
    func formatStyle_codableRoundTrip() throws {
        let original = Money.FormatStyle(
            locale: Locale(identifier: "en-US"),
            scale: 3,
            rounding: .up,
            sign: .always(),
            notation: .compactName
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Money.FormatStyle.self, from: data)
        #expect(original == decoded)
    }

    // MARK: - formatted() No-Arg

    @Test
    func formatted_noArg_matchesDefaultStyle() {
        let value = Money(amount: 19.25, currency: .USD)
        #expect(value.formatted() == value.formatted(.money()))
    }

    // MARK: - Deprecated localizedString Parity

    @Test
    func localizedString_deprecated_matchesFormatted() {
        let enUS = Locale(identifier: "en-US")
        let value = Money(amount: 19.125, currency: .USD)
        // Verify the deprecated shim produces identical output to the new API, including the scale fix.
        #expect(
            value.localizedString(locale: enUS, scale: 3) ==
            value.formatted(.money(locale: enUS, scale: 3))
        )
        #expect(
            value.localizedString(locale: enUS) ==
            value.formatted(.money(locale: enUS))
        )
    }
}
