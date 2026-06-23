public import Foundation

// MARK: - Money.FormatStyle

extension Money {
    /// A `FormatStyle` that produces a localized, currency-aware string from a ``Money`` value.
    ///
    /// Use ``Money/formatted()`` or ``Money/formatted(_:)`` to format a value, or build a style
    /// using the ``Foundation/FormatStyle`` static accessors ``money`` and ``money(locale:scale:rounding:sign:notation:)``:
    ///
    /// ```swift
    /// let price = Money(amount: 12_250.25, currency: .USD)
    /// price.formatted()                                    // "$12,250.25" (autoupdating locale)
    /// price.formatted(.money(locale: Locale(identifier: "en-US")))
    /// price.formatted(.money(notation: .compactName))      // "$12K"
    /// Text(price, format: .money)                          // SwiftUI integration
    /// ```
    ///
    /// Configure a style using fluent modifiers:
    ///
    /// ```swift
    /// let style = Money.FormatStyle()
    ///     .locale(Locale(identifier: "en-US"))
    ///     .scale(0)
    ///     .sign(strategy: .always())
    /// price.formatted(style)
    /// ```
    ///
    /// - Important: If no scale is provided, the value's currency minor units are used.
    public struct FormatStyle: Sendable {

        // MARK: Properties

        /// The locale used to format the value. Defaults to `.autoupdatingCurrent`.
        public var locale: Locale

        /// The number of fraction digits to display. When `nil`, the value's currency minor units are used.
        public var scale: Int?

        /// The rounding mode applied before formatting. Defaults to `.bankers`.
        public var rounding: NSDecimalNumber.RoundingMode

        /// The strategy used to display the sign of the value. Defaults to `.automatic`.
        public var sign: Decimal.FormatStyle.Currency.Configuration.SignDisplayStrategy

        /// The notation used to format the value. Defaults to `.automatic`.
        public var notation: Decimal.FormatStyle.Currency.Configuration.Notation

        // MARK: Initializer

        /// Creates a money format style.
        ///
        /// - Important: If no scale is provided, the value's currency minor units are used.
        public init(
            locale: Locale = .autoupdatingCurrent,
            scale: Int? = nil,
            rounding: NSDecimalNumber.RoundingMode = .bankers,
            sign: Decimal.FormatStyle.Currency.Configuration.SignDisplayStrategy = .automatic,
            notation: Decimal.FormatStyle.Currency.Configuration.Notation = .automatic
        ) {
            self.locale = locale
            self.scale = scale
            self.rounding = rounding
            self.sign = sign
            self.notation = notation
        }
    }
}

// MARK: - Money.FormatStyle + FormatStyle

extension Money.FormatStyle: FormatStyle {
    /// Returns a localized string representation of the provided ``Money`` value.
    public func format(_ value: Money) -> String {
        let scale = scale ?? value.currency.minorUnits
        let style = Decimal.FormatStyle.Currency
            .currency(code: value.currency.id)
            .locale(locale)
            .precision(.fractionLength(scale))
            .decimalSeparator(strategy: .automatic)
            .grouping(.automatic)
            .presentation(.standard)
            .sign(strategy: sign)
            .notation(notation)
        let rounded = value.rounded(scale: scale, mode: rounding)
        return style.format(rounded.amount)
    }

    /// Returns a copy of the style configured to use the provided locale.
    public func locale(_ locale: Locale) -> Self {
        var copy = self
        copy.locale = locale
        return copy
    }
}

// MARK: - Money.FormatStyle + Modifiers

extension Money.FormatStyle {
    /// Returns a copy of the style configured to display the provided number of fraction digits.
    ///
    /// - Important: Passing `nil` restores the default behavior of using the value's currency minor units.
    public func scale(_ scale: Int?) -> Self {
        var copy = self
        copy.scale = scale
        return copy
    }

    /// Returns a copy of the style configured to use the provided rounding mode.
    public func rounding(_ rounding: NSDecimalNumber.RoundingMode) -> Self {
        var copy = self
        copy.rounding = rounding
        return copy
    }

    /// Returns a copy of the style configured to use the provided sign display strategy.
    public func sign(strategy: Decimal.FormatStyle.Currency.Configuration.SignDisplayStrategy) -> Self {
        var copy = self
        copy.sign = strategy
        return copy
    }

    /// Returns a copy of the style configured to use the provided notation.
    public func notation(_ notation: Decimal.FormatStyle.Currency.Configuration.Notation) -> Self {
        var copy = self
        copy.notation = notation
        return copy
    }
}

// MARK: - Money.FormatStyle + Hashable

extension Money.FormatStyle: Hashable {}

// MARK: - Money.FormatStyle + Codable

extension Money.FormatStyle: Codable {
    private enum CodingKeys: String, CodingKey {
        case locale, scale, rounding, sign, notation
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locale = try container.decode(Locale.self, forKey: .locale)
        self.scale = try container.decodeIfPresent(Int.self, forKey: .scale)
        let rawRounding = try container.decode(UInt.self, forKey: .rounding)
        self.rounding = NSDecimalNumber.RoundingMode(rawValue: rawRounding) ?? .bankers
        self.sign = try container.decode(
            Decimal.FormatStyle.Currency.Configuration.SignDisplayStrategy.self, forKey: .sign
        )
        self.notation = try container.decode(
            Decimal.FormatStyle.Currency.Configuration.Notation.self, forKey: .notation
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(locale, forKey: .locale)
        try container.encodeIfPresent(scale, forKey: .scale)
        try container.encode(rounding.rawValue, forKey: .rounding)
        try container.encode(sign, forKey: .sign)
        try container.encode(notation, forKey: .notation)
    }
}

// MARK: - Money + Formatted

extension Money {
    /// Returns a string representation of the value using the default ``Money/FormatStyle``.
    ///
    /// Uses the autoupdating current locale and the value's currency minor units.
    public func formatted() -> String {
        Money.FormatStyle().format(self)
    }

    /// Returns a representation of the value formatted using the provided style.
    public func formatted<S: Foundation.FormatStyle>(_ style: S) -> S.FormatOutput where S.FormatInput == Money {
        style.format(self)
    }
}

// MARK: - FormatStyle + Money

extension FormatStyle where Self == Money.FormatStyle {
    /// A money format style using default configuration.
    public static var money: Money.FormatStyle {
        Money.FormatStyle()
    }

    /// A money format style using the provided configuration.
    ///
    /// - Important: If no scale is provided, the value's currency minor units are used.
    public static func money(
        locale: Locale = .autoupdatingCurrent,
        scale: Int? = nil,
        rounding: NSDecimalNumber.RoundingMode = .bankers,
        sign: Decimal.FormatStyle.Currency.Configuration.SignDisplayStrategy = .automatic,
        notation: Decimal.FormatStyle.Currency.Configuration.Notation = .automatic
    ) -> Money.FormatStyle {
        Money.FormatStyle(
            locale: locale,
            scale: scale,
            rounding: rounding,
            sign: sign,
            notation: notation
        )
    }
}
