import Foundation

/// A representation of a monetary amount in a given currency.
///
/// ``Money/Money`` is backed by a `Decimal` amount instead of an integer or
/// binary floating-point numbers.
///
/// - **binary floating point numbers** don't maintain the level of precision necessary
///                              when dealing with most factors of 10.
///
/// - **integers** run into problems when you multiple or divide by fractional amounts,
///              such as when you're calculating exchange rates. After each operation,
///              the value would need to round any remainder. These errors can
///              accumulate and cause incorrect amounts.
public struct Money {

    // MARK: Properties

    /// The decimal representation of the amount of money.
    public var amount: Decimal

    /// The currency of the money.
    public var currency: any Currency

    // MARK: Initializers

    /// Creates a monetary value from the provided amount and currency.
    @inlinable public init<C: Currency>(amount: Decimal, currency: C) {
        self.amount = amount
        self.currency = currency
    }

    /// Creates a monetary value from the provided minor units and currency.
    @inlinable public init<C: Currency>(minorUnits: Int, currency: C) {
        precondition(currency.minorUnits >= 0)

        let sign: FloatingPointSign = minorUnits >= 0 ? .plus : .minus
        let exponent = -currency.minorUnits
        let significand = Decimal(abs(minorUnits))

        let amount = Decimal(
            sign: sign,
            exponent: exponent,
            significand: significand
        )

        self.init(amount: amount, currency: currency)
    }
}

// MARK: - Money + CustomStringConvertible

extension Money: CustomStringConvertible {
    @inlinable public var description: String {
        "\(amount) (\(currency.id))"
    }
}

// MARK: - Money + Equatable

extension Money: Equatable {
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.currency.isEqual(to: rhs.currency) && lhs.amount == rhs.amount
    }
}

// MARK: - Money + Rounding

extension Money {
    /// A rounded version of the monetary value using the value's `currency`.
    @inlinable public func rounded() -> Self {
        var copy = self
        copy.amount.rounding(for: currency)
        return copy
    }

    /// Rounds the monetary value using the value's ``Money/currency``.
    @inlinable public mutating func round() {
        self = rounded()
    }
}

// MARK: - Money + Conversion

extension Money {
    /// A monetary value converted to the provided base ``Currency`` using the specified `rate`.
    ///
    /// - Important: The currency passed as a parameter is considered the `base` currency
    /// while the currency of the monetary value is considered the `quote` currency. The `base`
    /// currency's value is always equal to 1 unit, while the `quote` currency's value represents
    /// how much of that currency is needed to purchase one unit of the `base` currency.
    ///
    /// Say we want to convert dollars (**USD**) to sterling (**GBP**). This can be represented
    /// as the currency pair **GBP/USD**.
    ///
    /// A currency pair has a `base` currency and a `quote` currency. In our example, **GBP**
    /// is the `base` and **USD** is the `quote`.
    ///
    /// If the exchange rate is 1.25, this means that 1 **GBP** is equivalent to 1.25 **USD**.
    /// The `base` currency's value is always equal to 1 unit, while the `quote` currency's value
    /// represents how much of that currency is needed to purchase one unit of the `base` currency.
    ///
    /// ```swift
    /// let dollars = Money(amount: 5.0, currency: .USD)
    /// let sterling = dollars.converted(to: .GBP, rate: 1.25)
    /// print(sterling.amount) // 4.0
    /// ```
    @inlinable public func converted<C: Currency>(
        to base: C,
        rate: Decimal
    ) -> Self {
        var copy = self
        copy.amount = copy.amount / rate
        copy.currency = base
        return copy
    }

    /// Converts the monetary value to the provided ``Currency`` using the specified `rate`.
    ///
    /// - Important: The currency passed as a parameter is considered the `base` currency
    /// while the currency of the monetary value is considered the `quote` currency. The `base`
    /// currency's value is always equal to 1 unit, while the `quote` currency's value represents
    /// how much of that currency is needed to purchase one unit of the `base` currency.
    ///
    /// Say we want to convert dollars (**USD**) to sterling (**GBP**). This can be represented
    /// as the currency pair **GBP/USD**.
    ///
    /// A currency pair has a `base` currency and a `quote` currency. In our example, **GBP**
    /// is the `base` and **USD** is the `quote`.
    ///
    /// If the exchange rate is 1.25, this means that 1 **GBP** is equivalent to 1.25 **USD**.
    /// The `base` currency's value is always equal to 1 unit, while the `quote` currency's value
    /// represents how much of that currency is needed to purchase one unit of the `base` currency.
    ///
    /// ```swift
    /// let dollars = Money(amount: 5.0, currency: .USD)
    /// let sterling = dollars.converted(to: .GBP, rate: 1.25)
    /// print(sterling.amount) // 4.0
    /// ```
    @inlinable public mutating func convert<C: Currency>(
        to currency: C,
        rate: Decimal
    ) {
        self = converted(to: currency, rate: rate)
    }
}

// MARK: - Money + Arithmetic

extension Money {

    // MARK: Addition

    /// The sum of a monetary value and a decimal amount.
    @inlinable public static func + (lhs: Self, rhs: Decimal) -> Self {
        var copy = lhs
        copy.amount = lhs.amount + rhs
        return copy
    }

    /// The sum of a decimal amount and a monetary value.
    @inlinable public static func + (lhs: Decimal, rhs: Self) -> Self {
        rhs + lhs
    }

    /// The sum of a monetary value and an integer amount.
    @inlinable  public static func + (lhs: Self, rhs: Int) -> Self {
        lhs + Decimal(rhs)
    }

    /// The sum of an integer amount and a monetary value.
    @inlinable public static func + (lhs: Int, rhs: Self) -> Self {
        Decimal(lhs) + rhs
    }

    /// The aggregated monetary sum of two monetary values.
    @inlinable public static func + (lhs: Self, rhs: Self) -> AggregatedMoney {
        AggregatedMoney(money: lhs) + rhs
    }

    /// Adds a decimal amount to a monetary amount.
    @inlinable public static func += (lhs: inout Self, rhs: Decimal) {
        lhs = lhs + rhs
    }

    /// Adds an integer amount to a monetary amount.
    @inlinable public static func += (lhs: inout Self, rhs: Int) {
        lhs = lhs + rhs
    }

    // MARK: Subtraction

    /// The difference of a monetary value and a decimal amount.
    @inlinable public static func - (lhs: Self, rhs: Decimal) -> Self {
        var copy = lhs
        copy.amount = lhs.amount - rhs
        return copy
    }

    /// The difference of a decimal amount and a monetary value.
    @inlinable public static func - (lhs: Decimal, rhs: Self) -> Self {
        lhs + -rhs
    }

    /// The difference of a monetary value and an integer amount.
    @inlinable public static func - (lhs: Self, rhs: Int) -> Self {
        lhs - Decimal(rhs)
    }

    /// The difference of an integer amount and a monetary value.
    @inlinable public static func - (lhs: Int, rhs: Self) -> Self {
        Decimal(lhs) - rhs
    }

    /// The aggregated monetary difference of two monetary values.
    @inlinable public static func - (lhs: Self, rhs: Self) -> AggregatedMoney {
        AggregatedMoney(money: lhs) - rhs
    }

    /// Subtracts a decimal amount from a monetary amount.
    @inlinable public static func -= (lhs: inout Self, rhs: Decimal) {
        lhs = lhs - rhs
    }

    /// Subtracts an integer amount from a monetary amount.
    @inlinable public static func -= (lhs: inout Self, rhs: Int) {
        lhs = lhs - rhs
    }

    // MARK: Multiplication

    /// The product of a monetary value and a scalar value.
    @inlinable public static func * (lhs: Self, rhs: Decimal) -> Self {
        var copy = lhs
        copy.amount = lhs.amount * rhs
        return copy
    }

    /// The product of a scalar value and a monetary value.
    @inlinable public static func * (lhs: Decimal, rhs: Self) -> Self {
        rhs * lhs
    }

    /// The product of a monetary value and a scalar value.
    @inlinable public static func * (lhs: Self, rhs: Int) -> Self {
        lhs * Decimal(rhs)
    }

    /// The product of a scalar value and a monetary value.
    @inlinable public static func * (lhs: Int, rhs: Self) -> Self {
        rhs * lhs
    }

    /// Multiplies a monetary value by a scalar value.
    @inlinable public static func *= (lhs: inout Self, rhs: Decimal) {
        lhs = lhs * rhs
    }

    /// Multiplies a monetary value by a scalar value.
    @inlinable public static func *= (lhs: inout Self, rhs: Int) {
        lhs = lhs * rhs
    }

    // MARK: Division

    /// The quotient of a monetary value and a scalar value.
    @inlinable public static func / (lhs: Self, rhs: Decimal) -> Self {
        var copy = lhs
        copy.amount = lhs.amount / rhs
        return copy
    }

    /// The quotient of a scalar value and a monetary value.
    @inlinable public static func / (lhs: Decimal, rhs: Self) -> Self {
        var copy = rhs
        copy.amount = lhs / rhs.amount
        return copy
    }

    /// The quotient of a monetary value and a scalar value.
    @inlinable public static func / (lhs: Self, rhs: Int) -> Self {
        lhs / Decimal(rhs)
    }

    /// The quotient of a scalar value and a monetary value.
    @inlinable public static func / (lhs: Int, rhs: Self) -> Self {
        Decimal(lhs) / rhs
    }

    /// Divides a monetary value by a scalar value.
    @inlinable public static func /= (lhs: inout Self, rhs: Decimal) {
        lhs = lhs / rhs
    }

    /// Divides a monetary value by a scalar value.
    @inlinable public static func /= (lhs: inout Self, rhs: Int) {
        lhs = lhs / rhs
    }

    // MARK: Negation

    @inlinable public static prefix func - (value: Self) -> Self {
        var copy = value
        copy.amount = -copy.amount
        return copy
    }
}
