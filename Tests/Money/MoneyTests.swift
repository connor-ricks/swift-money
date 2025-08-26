import Foundation
import InlineSnapshotTesting
@testable import Money
import Testing

// swiftlint:disable shorthand_operator

@Suite
struct MoneyTests {
    // MARK: Initialization Tests

    @Test
    func money_whenInitializedMatchesParameters() {
        let foo = Money(amount: 2.5, currency: .foo)
        #expect(foo.amount == 2.5)
        #expect(foo.currency.isEqual(to: .foo))
        #expect(foo.currency.minorUnits == MockCurrency.foo.minorUnits)

        let bar = Money(minorUnits: 50, currency: .biz)
        #expect(bar.amount == 0.5)
        #expect(bar.currency.isEqual(to: .biz))
        #expect(bar.currency.minorUnits == MockCurrency.biz.minorUnits)

        let baz = Money(amount: -2.5, currency: .foo)
        #expect(baz.amount == -2.5)
        #expect(baz.currency.isEqual(to: .foo))
        #expect(baz.currency.minorUnits == MockCurrency.foo.minorUnits)

        let biz = Money(minorUnits: -50, currency: .biz)
        #expect(biz.amount == -0.5)
        #expect(biz.currency.isEqual(to: .biz))
        #expect(biz.currency.minorUnits == MockCurrency.biz.minorUnits)

        print(foo)
    }

    @Test
    func money_initializedThroughAmountsAndMinorUnitsWithSameValue_arEqual() {
        let foo1 = Money(amount: 10, currency: .foo)
        let foo2 = Money(minorUnits: 10, currency: .foo)
        #expect(foo1 == foo2)

        let bar1 = Money(amount: 1.5, currency: .bar)
        let bar2 = Money(minorUnits: 15, currency: .bar)
        #expect(bar1 == bar2)

        let biz1 = Money(amount: 1.55, currency: .biz)
        let biz2 = Money(minorUnits: 155, currency: .biz)
        #expect(biz1 == biz2)
    }

    // MARK: Equatable Tests

    @Test
    func money_withMatchingAmountsAndSameCurrency_areEqual() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1, currency: .foo)
        #expect(foo == bar)
    }

    @Test
    func money_withMatchingAmountsAndDifferentCurrencies_areNotEqual() {
        #expect(Money(amount: 1, currency: .foo) != Money(amount: 1, currency: .bar))
    }

    @Test
    func money_withDifferentAmounts_areNotEqual() {
        #expect(Money(amount: 1, currency: .foo) != Money(amount: 1.1, currency: .foo))
    }

    // MARK: Rounding Tests

    @Test
    func money_whenRounded_roundsToCurrencyMinorUnits() {
        let foo = Money(amount: 2.5, currency: .foo)
        #expect(foo.rounded().amount == 2)

        var bar = Money(amount: 2.5, currency: .foo)
        bar.round()
        #expect(bar.amount == 2)

        let biz = Money(amount: 2.3333333, currency: .baz)
        #expect(biz.rounded().amount == 2.333)

        var baz = Money(amount: 2.3333333, currency: .baz)
        baz.round()
        #expect(baz.amount == 2.333)
    }

    // MARK: Converting Tests

    @Test
    func money_whenConverted_matchesRateAndCurrency() {
        let biz = Money(amount: 10, currency: .foo)
        let convertedBiz = biz.converted(to: .bar, rate: 0.5)
        #expect(convertedBiz == Money(amount: 20, currency: .bar))

        var baz = Money(amount: 10, currency: .foo)
        baz.convert(to: .bar, rate: 0.5)
        #expect(baz == Money(amount: 20, currency: .bar))

        let dollars = Money(amount: 100, currency: .USD)
        #expect(dollars.converted(to: .GBP, rate: 1.25) == Money(amount: 80, currency: .GBP))
        #expect(dollars.converted(to: .GBP, rate: 0.8) == Money(amount: 125, currency: .GBP))
    }

    // MARK: Arithmetic Tests

    @Test
    func money_whenAddedWithDecimal_updatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        #expect(foo + Decimal(5) == Money(amount: 6, currency: .foo))
        #expect(foo + Decimal(-1) == Money(amount: 0, currency: .foo))
        #expect(Decimal(3) + foo == Money(amount: 4, currency: .foo))
        #expect(Decimal(-2) + foo == Money(amount: -1, currency: .foo))

        var bar = Money(amount: 0, currency: .bar)
        bar += Decimal(1)
        #expect(bar == Money(amount: 1, currency: .bar))

        bar += Decimal(-5)
        #expect(bar == Money(amount: -4, currency: .bar))
    }

    @Test
    func money_whenAddedWithInt_increasesupdatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        #expect(foo + 5 == Money(amount: 6, currency: .foo))
        #expect(foo + -1 == Money(amount: 0, currency: .foo))
        #expect(3 + foo == Money(amount: 4, currency: .foo))
        #expect(-2 + foo == Money(amount: -1, currency: .foo))

        var bar = Money(amount: 0, currency: .bar)
        bar += 1
        #expect(bar == Money(amount: 1, currency: .bar))

        bar += -5
        #expect(bar == Money(amount: -4, currency: .bar))
    }

    @Test
    func money_whenSubtractedWithDecimal_updatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        #expect(foo - Decimal(5) == Money(amount: -4, currency: .foo))
        #expect(foo - Decimal(-1) == Money(amount: 2, currency: .foo))
        #expect(Decimal(3) - foo == Money(amount: 2, currency: .foo))
        #expect(Decimal(-2) - foo == Money(amount: -3, currency: .foo))

        var bar = Money(amount: 0, currency: .bar)
        bar -= Decimal(1)
        #expect(bar == Money(amount: -1, currency: .bar))

        bar -= Decimal(-5)
        #expect(bar == Money(amount: 4, currency: .bar))
    }

    @Test
    func money_whenSubtractedWithInt_updatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        #expect(foo - 5 == Money(amount: -4, currency: .foo))
        #expect(foo - -1 == Money(amount: 2, currency: .foo))
        #expect(3 - foo == Money(amount: 2, currency: .foo))
        #expect(-2 - foo == Money(amount: -3, currency: .foo))

        var bar = Money(amount: 0, currency: .bar)
        bar -= 1
        #expect(bar == Money(amount: -1, currency: .bar))

        bar -= -5
        #expect(bar == Money(amount: 4, currency: .bar))
    }

    @Test
    func money_whenAddedWithMoneyThatHasSameCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .foo)
        let biz = foo + bar

        #expect(biz == AggregatedMoney(amounts: [
            .init(.foo): 2.5
        ]))
    }

    @Test
    func money_whenAddedWithMoneyThatHasDifferentCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .bar)
        let biz = foo + bar

        #expect(biz[.foo] == 1)
        #expect(biz[.bar] == 1.5)
        #expect(biz.currencies.count == 2)
    }

    @Test
    func money_whenSubractedWithMoneyThatHasSameCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .foo)
        let biz = foo - bar

        #expect(biz[.foo] == -0.5)
        #expect(biz.currencies.count == 1)
    }

    @Test
    func money_whenSubtractedWithMoneyThatHasDifferentCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .bar)
        let biz = foo - bar

        #expect(biz[.foo] == 1)
        #expect(biz[.bar] == -1.5)
        #expect(biz.currencies.count == 2)
    }

    @Test
    func money_whenMultipliedByAScalarValue_multipliesAmountCorrectly() {
        var money = Money(amount: 2, currency: .foo)

        // Decimal
        money = money * Decimal(-3)
        #expect(money == Money(amount: -6, currency: .foo))

        money = Decimal(2) * money
        #expect(money == Money(amount: -12, currency: .foo))

        money *= Decimal(-5)
        #expect(money == Money(amount: 60, currency: .foo))

        // Int
        money = money * Int(-2)
        #expect(money == Money(amount: -120, currency: .foo))

        money = Int(-3) * money
        #expect(money == Money(amount: 360, currency: .foo))

        money *= Int(2)
        #expect(money == Money(amount: 720, currency: .foo))
    }

    @Test
    func money_whenDividedByAScalarValue_dividesAmountCorrectly() {
        var money = Money(amount: 720, currency: .foo)

        // Decimal
        money = money / Decimal(2)
        #expect(money == Money(amount: 360, currency: .foo))

        money = Decimal(-43_200) / money
        #expect(money == Money(amount: -120, currency: .foo))

        money /= Decimal(-2)
        #expect(money == Money(amount: 60, currency: .foo))

        // Int
        money = money / Int(-5)
        #expect(money == Money(amount: -12, currency: .foo))

        money = Int(72) / money
        #expect(money == Money(amount: -6, currency: .foo))

        money /= Int(-3)
        #expect(money == Money(amount: 2, currency: .foo))
    }

    @Test
    func money_whenNegated_doesNegateAmount() {
        var money = Money(amount: 10, currency: .foo)

        money = -money
        #expect(money == Money(amount: -10, currency: .foo))

        money = -money
        #expect(money == Money(amount: 10, currency: .foo))
    }

    // MARK: Localization Tests

    @Test
    func usd_localize_enUS() {
        let locale = Locale(identifier: "en-US")
        assertInlineSnapshot(of: Money(amount: -12_250.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            -$12,250.25
            """
        }
        assertInlineSnapshot(of: Money(amount: -19.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            -$19.25
            """
        }
        assertInlineSnapshot(of: Money(amount: -19, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            -$19.00
            """
        }
        assertInlineSnapshot(of: Money(amount: 0, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            $0.00
            """
        }
        assertInlineSnapshot(of: Money(amount: 19, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            $19.00
            """
        }
        assertInlineSnapshot(of: Money(amount: 19.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            $19.25
            """
        }
        assertInlineSnapshot(of: Money(amount: 12_250.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            $12,250.25
            """
        }
    }

    @Test
    func usd_localize_frFR() {
        let locale = Locale(identifier: "fr-FR")
        assertInlineSnapshot(of: Money(amount: -12_250.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            -12 250,25 $US
            """
        }
        assertInlineSnapshot(of: Money(amount: -19.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            -19,25 $US
            """
        }
        assertInlineSnapshot(of: Money(amount: -19, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            -19,00 $US
            """
        }
        assertInlineSnapshot(of: Money(amount: 0, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            0,00 $US
            """
        }
        assertInlineSnapshot(of: Money(amount: 19, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            19,00 $US
            """
        }
        assertInlineSnapshot(of: Money(amount: 19.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            19,25 $US
            """
        }
        assertInlineSnapshot(of: Money(amount: 12_250.25, currency: .USD).localizedString(locale: locale), as: .description) {
            """
            12 250,25 $US
            """
        }
    }

    @Test
    func eur_localize_enUS() {
        let locale = Locale(identifier: "en-US")
        assertInlineSnapshot(of: Money(amount: -12_250.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            -€12,250.25
            """
        }
        assertInlineSnapshot(of: Money(amount: -19.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            -€19.25
            """
        }
        assertInlineSnapshot(of: Money(amount: -19, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            -€19.00
            """
        }
        assertInlineSnapshot(of: Money(amount: 0, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            €0.00
            """
        }
        assertInlineSnapshot(of: Money(amount: 19, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            €19.00
            """
        }
        assertInlineSnapshot(of: Money(amount: 19.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            €19.25
            """
        }
        assertInlineSnapshot(of: Money(amount: 12_250.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            €12,250.25
            """
        }
    }

    @Test
    func eur_localize_frFR() {
        let locale = Locale(identifier: "fr-FR")
        assertInlineSnapshot(of: Money(amount: -12_250.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            -12 250,25 €
            """
        }
        assertInlineSnapshot(of: Money(amount: -19.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            -19,25 €
            """
        }
        assertInlineSnapshot(of: Money(amount: -19, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            -19,00 €
            """
        }
        assertInlineSnapshot(of: Money(amount: 0, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            0,00 €
            """
        }
        assertInlineSnapshot(of: Money(amount: 19, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            19,00 €
            """
        }
        assertInlineSnapshot(of: Money(amount: 19.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            19,25 €
            """
        }
        assertInlineSnapshot(of: Money(amount: 12_250.25, currency: .EUR).localizedString(locale: locale), as: .description) {
            """
            12 250,25 €
            """
        }
    }
}

// swiftlint:enable shorthand_operator
