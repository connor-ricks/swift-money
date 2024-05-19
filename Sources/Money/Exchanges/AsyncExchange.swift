import Foundation

// MARK: - AsyncExchange

/// An exchange that provides the ability to retrieve the rate of exchange between two given currencies, and trade monetary values of one currency
/// for monetary values of another.
public protocol AsyncExchange {
    /// Retrieves an exchange rate from the provided `base` and `quote`  currencies.
    func rate<Base: Currency, Quote: Currency>(base: Base, quote: Quote) async throws -> Decimal
}

// MARK: - AsyncExchange + Trading

extension AsyncExchange {
    /// Attempts to convert the provided monetary value into the provided currency using the exchange's conversion rate.
    @inlinable public func trade<C: Currency>(_ money: Money, for currency: C) async throws -> Money {
        guard !currency.isEqual(to: money.currency) else { return money }
        let rate = try await rate(base: currency, quote: money.currency)
        return Money(amount: money.amount / rate, currency: currency)
    }

    /// Attempts to convert the provided aggregated monetary value into the provided currency using the exchange's conversion rate.
    ///
    /// Each currency's amount in the aggregated monetary value will be converted to the provided currency using the exchange's conversion rate.
    /// Each of these monetary values will then be summed in order to provide a monetary value in the provided currency.
    public func trade<C: Currency>(_ aggregatedMoney: AggregatedMoney, for currency: C) async throws -> Money {
        var money = Money(amount: 0, currency: currency)
        for aggregatedCurrency in aggregatedMoney.currencies {
            guard let amount = aggregatedMoney[aggregatedCurrency] else { continue }
            if aggregatedCurrency.isEqual(to: currency) {
                money += amount
            } else {
                let rate = try await rate(base: currency, quote: aggregatedCurrency)
                money += amount / rate
            }
        }

        return money
    }
}
