# Currency Conversion

Convert monetary values between different currencies using exchange rates and exchange protocols.

## Overview

The Money framework provides flexible mechanisms for converting monetary values between different currencies. You can perform quick conversions with explicit rates or implement sophisticated exchange systems using the `Exchange` and `AsyncExchange` protocols.

## Quick Conversion

### Direct Rate Conversion

For simple, one-off conversions, use the `converted` method with an explicit exchange rate:

```swift
let dollars = Money(amount: 100, currency: .USD)

// Convert $100 to GBP at rate 0.8 (1 USD = 0.8 GBP)
let pounds = dollars.converted(to: .GBP, rate: 0.8)
// Result: £80

// Convert $100 to EUR at rate 0.92 (1 USD = 0.92 EUR)  
let euros = dollars.converted(to: .EUR, rate: 0.92)
// Result: €92
```

### In-Place Conversion

You can also convert money in place using the `convert` method:

```swift
var amount = Money(amount: 100, currency: .USD)
amount.convert(to: .GBP, rate: 0.8)
// amount is now £80
```

## Exchange Protocols

For more sophisticated conversion needs, the framework provides two exchange protocols:

### Exchange Protocol

The synchronous `Exchange` protocol is ideal for exchanges with pre-loaded or cached rates:

```swift
struct FixedRateExchange: Exchange {
    private let rates: [String: Decimal]
    
    init(rates: [String: Decimal]) {
        self.rates = rates
    }
    
    func rate(converting base: Currency, to quote: Currency) throws -> Decimal {
        let key = "\(base.id)/\(quote.id)"
        guard let rate = rates[key] else {
            throw ExchangeError.unsupportedPair
        }
        return rate
    }
}

// Usage
let exchange = FixedRateExchange(rates: [
    "USD/GBP": 0.8,
    "USD/EUR": 0.92,
    "GBP/EUR": 1.15
])

let dollars = Money(amount: 100, currency: .USD)
let pounds = try exchange.trade(dollars, for: .GBP)  // £80
```

### AsyncExchange Protocol

The asynchronous `AsyncExchange` protocol is perfect for fetching live rates from APIs:

```swift
struct LiveRateExchange: AsyncExchange {
    private let apiClient: ExchangeRateAPI
    
    func rate(converting base: Currency, to quote: Currency) async throws -> Decimal {
        let response = await apiClient.fetchRate(from: base.id, to: quote.id)
        guard let rate = response.rate else {
            throw ExchangeError.rateFetchFailed
        }
        return rate
    }
}

// Usage
let exchange = LiveRateExchange(apiClient: api)
let dollars = Money(amount: 100, currency: .USD)
let pounds = try await exchange.trade(dollars, for: .GBP)
```

## Converting AggregatedMoney

When converting `AggregatedMoney`, each currency in the collection is converted and summed:

```swift
let aggregated = AggregatedMoney([
    Money(amount: 100, currency: .USD),  // Needs USD/GBP rate
    Money(amount: 50, currency: .EUR)    // Needs EUR/GBP rate
])

// Assuming exchange has rates: USD/GBP = 0.8, EUR/GBP = 0.87
let totalInGBP = try await exchange.trade(aggregated, for: .GBP)
// Result: (100 * 0.8) + (50 * 0.87) = £123.50
```
