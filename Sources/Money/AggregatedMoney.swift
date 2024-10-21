import Foundation

// MARK: - AggregatedMoney

/// A representation of aggregated monetary values across various currencies.
///
/// Performing arithmetic operations across monetary value is not as easy as adding
/// up their ``Money/Money/amount`` values. This is because ``Money/Money``
/// is also represented by a ``Currency``. Monetary amounts with mismatched currencies
/// cannot simply be added together, as that would not take into account exchange rate
/// between the two values.
///
/// ``AggregatedMoney`` solves this problem by allowing you to safely
/// and reliably perform arithmetic operations.
public struct AggregatedMoney {

    // MARK: Key

    /// A key used to identify an amount for a given ``Currency`` within the
    /// aggregated monetary amounts.
    ///
    /// The ``Currency`` protocol itself cannot be hashable, so this key wraps a
    /// currency and provides a hashable implementation using ``AnyHashable``
    /// while still maintaining access to the underlying currency.
    struct Key: Hashable {
        let currency: any Currency

        init(_ currency: any Currency) {
            self.currency = currency
        }

        static func == (
            lhs: AggregatedMoney.Key,
            rhs: AggregatedMoney.Key
        ) -> Bool {
            lhs.currency.isEqual(to: rhs.currency)
        }

        func hash(into hasher: inout Hasher) {
            func hash<C: Currency>(_ c: C) -> AnyHashable { .init(c) }
            hasher.combine(hash(currency))
        }
    }

    // MARK: Properties

    /// A mapping from currencies to decimal values, representing an
    /// aggregated monetary value.
    private var amounts: [Key: Decimal]

    /// An array of all of the currencies represented within the aggregated
    /// monetary value.
    var currencies: [any Currency] {
        amounts.keys.map { $0.currency }
    }

    // MARK: Initializers

    /// Creates an aggregated monetary value from the provided dictionary.
    init(amounts: [Key: Decimal]) {
        self.amounts = amounts
    }

    /// Creates an aggregated monetary value with no monetary value.
    public init() {
        self.init(amounts: [:])
    }

    /// Creates an aggregated monetary value from the provided amount
    /// and currency.
    @inlinable public init<C: Currency>(amount: Decimal, currency: C) {
        self.init(money: Money(amount: amount, currency: currency))
    }

    /// Creates an aggregated monetary value from the provided minor units and currency.
    @inlinable public init<C: Currency>(minorUnits: Int, currency: C) {
        self.init(money: Money(minorUnits: minorUnits, currency: currency))
    }

    /// Creates an aggregated monetary value with an amount equal to the summation of all the monetary
    /// values in the provided array.
    @inlinable public init(money: Money...) {
        self.init(money)
    }

    /// Creates an aggregated monetary value with an amount equal to the summation of all the monetary
    /// values in the provided sequence.
    public init<S: Sequence<Money>>(_ s: S) {
        self.amounts = s.reduce(into: [:]) { amounts, money in
            amounts[Key(money.currency), default: 0] += money.amount
        }
    }

    /// Creates an aggregated monetary value with an amount equal to the summation of all of the
    /// aggregated monetary values in the provided array.
    @inlinable public init(aggregatedMoney: Self...) {
        self.init(aggregatedMoney)
    }

    /// Creates an aggregated monetary value with an amount equal to the summation of all of the
    /// aggregated monetary values in the provided sequence.
    public init<S: Sequence<Self>>(_ s: S) {
        self.amounts = s.reduce(into: [:]) { amounts, aggregatedMoney in
            amounts = aggregatedMoney.amounts.reduce(
                into: amounts
            ) { amounts, item in
                amounts[item.key, default: 0] += item.value
            }
        }
    }

    // MARK: Subscripts

    subscript<C: Currency>(currency: C) -> Decimal? {
        get { amounts[Key(currency)] }
        set(newValue) { amounts[Key(currency)] = newValue }
    }

    subscript<C: Currency>(currency: C, default default: Decimal) -> Decimal {
        get { amounts[Key(currency)] ?? `default` }
        set(newValue) { amounts[Key(currency)] = newValue }
    }
}

// MARK: - Equatable

extension AggregatedMoney: Equatable {}

// MARK: - AggregatedMoney + Conversion

extension AggregatedMoney {
    /// An aggregated monetary value converted to the provided base ``Currency`` using the
    /// specified ``Exchange``.
    ///
    /// - Important: The currency passed as a parameter is considered the `base` currency
    /// while the currencies of the aggregated monetary value are considered the `quote` currencies.
    /// The `base` currency's value is always equal to 1 unit, while the `quote` currency's value
    /// represents how much of that currency is needed to purchase one unit of the `base` currency.
    ///
    /// Say we want to convert dollars (**USD**) and euros (**EUR**) to sterling (**GBP**).
    /// This can be represented as the currency pairs **GBP/USD** and **GBP/EUR**
    ///
    /// A currency pair has a `base` currency and a `quote` currency. In our example, **GBP** is
    /// the `base` and both  **USD** and **EUR**  are the `quote` currencies.
    ///
    /// Given the currency pair **GBP/USD**, if the exchange rate is 1.25, this means that 1 **GBP**
    /// is equivalent to 1.25 **USD**. The `base` currency's value is always equal to 1 unit, while
    /// the `quote` currency's value represents how much of that currency is needed to purchase
    /// one unit of the `base` currency.
    ///
    /// The function will attempt to convert each of the aggregated monetary value's currencies to
    /// the `base` currency, and sum their values together to get the total amount of the `quote`
    /// currency.
    ///
    /// ```swift
    /// let dollars = Money(amount: 5.0, currency: .USD)
    /// let euros = Money(amount: 10.0, currency: .EUR)
    ///
    /// let aggregatedMoney = AggregatedMoney(money: dollars, euros)
    /// let sterling = aggregatedMoney.converted(to: .GBP, using: exchange)
    /// print(sterling.amount) // 4.0
    /// ```
    public func converted<C: Currency, E: Exchange>(
        to base: C,
        using exchange: E
    ) throws -> Money {
        try exchange.trade(self, for: base)
    }

    /// An aggregated monetary value converted to the provided base ``Currency`` using the
    /// specified ``Exchange``.
    ///
    /// - Important: The currency passed as a parameter is considered the `base` currency
    /// while the currencies of the aggregated monetary value are considered the `quote` currencies.
    /// The `base` currency's value is always equal to 1 unit, while the `quote` currency's value
    /// represents how much of that currency is needed to purchase one unit of the `base` currency.
    ///
    /// Say we want to convert dollars (**USD**) and euros (**EUR**) to sterling (**GBP**).
    /// This can be represented as the currency pairs **GBP/USD** and **GBP/EUR**
    ///
    /// A currency pair has a `base` currency and a `quote` currency. In our example, **GBP** is
    /// the `base` and both  **USD** and **EUR**  are the `quote` currencies.
    ///
    /// Given the currency pair **GBP/USD**, if the exchange rate is 1.25, this means that 1 **GBP**
    /// is equivalent to 1.25 **USD**. The `base` currency's value is always equal to 1 unit, while the
    /// `quote` currency's value represents how much of that currency is needed to purchase one
    /// unit of the `base` currency.
    ///
    /// The function will attempt to convert each of the aggregated monetary value's currencies to
    /// the `base` currency, and sum their values together to get the total amount of
    /// the `quote` currency.
    ///
    /// ```swift
    /// let dollars = Money(amount: 5.0, currency: .USD)
    /// let euros = Money(amount: 10.0, currency: .EUR)
    ///
    /// let aggregatedMoney = AggregatedMoney(money: dollars, euros)
    /// let sterling = aggregatedMoney.converted(to: .GBP, using: exchange)
    /// print(sterling.amount) // 4.0
    /// ```
    public func converted<C: Currency, E: AsyncExchange>(
        to base: C,
        using asyncExchange: E
    ) async throws -> Money {
        try await asyncExchange.trade(self, for: base)
    }
}

// MARK: - AggregatedMoney + Arithmetic

extension AggregatedMoney {

    // MARK: Addition

    /// The sum of an aggregated monetary value and another aggregated monetary value.
    @inlinable public static func + (lhs: Self, rhs: Self) -> Self {
        AggregatedMoney([lhs, rhs])
    }

    /// The sum of an aggregated monetary value and a monetary value.
    @inlinable public static func + (lhs: Self, rhs: Money) -> Self {
        lhs + AggregatedMoney(money: rhs)
    }

    /// The sum of a monetary value and an aggregated monetary value.
    @inlinable public static func + (lhs: Money, rhs: Self) -> Self {
        AggregatedMoney(money: lhs) + rhs
    }

    /// Adds a monetary value to an aggregated monetary value.
    @inlinable public static func += (lhs: inout Self, rhs: Money) {
        lhs = lhs + rhs
    }

    /// Adds an aggregated monetary value to another aggregated monetary value.
    @inlinable public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    // MARK: Subtraction

    /// The difference of an aggregated monetary value and another aggregated monetary value.
    public static func - (lhs: Self, rhs: Self) -> Self {
        var copy = lhs
        copy.amounts = rhs.amounts.reduce(into: lhs.amounts) { amounts, item in
            amounts[item.key, default: 0] -= item.value
        }

        return copy
    }

    /// The difference of an aggregated monetary value and a monetary value.
    @inlinable public static func - (lhs: Self, rhs: Money) -> Self {
        lhs - AggregatedMoney(money: rhs)
    }

    /// The difference of a monetary value and an aggregated monetary value.
    @inlinable public static func - (lhs: Money, rhs: Self) -> Self {
        AggregatedMoney(money: lhs) - rhs
    }

    /// Subtracts a monetary value from an aggregated monetary value.
    @inlinable public static func -= (lhs: inout Self, rhs: Money) {
        lhs = lhs - rhs
    }

    /// Subtracts an aggregated monetary value from another aggregated monetary value.
    @inlinable public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    // MARK: Multiplication

    /// The product of an aggregated monetary value and a scalar value.
    public static func * (lhs: Self, rhs: Decimal) -> Self {
        var copy = lhs
        copy.amounts = copy.amounts.mapValues { $0 * rhs }
        return copy
    }

    /// The product of an aggregated monetary value and a scalar value.
    @inlinable public static func * (lhs: Self, rhs: Int) -> Self {
        lhs * Decimal(rhs)
    }

    /// Multiplies an aggregated monetary value by a scalar value.
    @inlinable public static func *= (lhs: inout Self, rhs: Decimal) {
        lhs = lhs * rhs
    }

    /// Multiplies an aggregated monetary value by a scalar value.
    @inlinable public static func *= (lhs: inout Self, rhs: Int) {
        lhs = lhs * rhs
    }

    // MARK: Division

    /// The quotient of an aggregated monetary value and a scalar value..
    public static func / (lhs: Self, rhs: Decimal) -> Self {
        var copy = lhs
        copy.amounts = copy.amounts.mapValues { $0 / rhs }
        return copy
    }

    /// The quotient of an aggregated monetary value and a scalar value..
    @inlinable public static func / (lhs: Self, rhs: Int) -> Self {
        lhs / Decimal(rhs)
    }

    /// Divides an aggregated monetary value by a scalar value..
    @inlinable public static func /= (lhs: inout Self, rhs: Decimal) {
        lhs = lhs / rhs
    }

    /// Divides an aggregated monetary value by a scalar value..
    @inlinable public static func /= (lhs: inout Self, rhs: Int) {
        lhs = lhs / rhs
    }

    // MARK: Negation

    public static prefix func - (value: Self) -> Self {
        var copy = value
        copy.amounts = copy.amounts.mapValues { -$0 }
        return copy
    }
}
