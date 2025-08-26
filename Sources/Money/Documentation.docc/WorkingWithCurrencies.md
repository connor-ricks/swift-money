# Working with Currencies

Understand the currency system and learn how to work with both predefined and custom currencies.

## Overview

The Money framework provides a flexible currency system based on the `Currency` protocol. It includes comprehensive support for ISO 4217 currencies out of the box and allows you to define custom currencies for specialized use cases.

## The Currency Protocol

All currencies conform to the `Currency` protocol, which defines the essential properties:

```swift
protocol Currency {
    var id: String { get }
    var minorUnits: Int { get }
}
```

- `id`: A unique identifier for the currency
- `minorUnits`: The number of decimal places for the minor unit (e.g., 2 for cents in USD)

## ISO 4217 Currencies

### Using Predefined Currencies

The framework includes a predefined list of major ISO 4217 currencies as static properties on `Currency`:

```swift
// Common currencies
let usd = Money(amount: 100, currency: .USD)  // US Dollar
let eur = Money(amount: 100, currency: .EUR)  // Euro
let gbp = Money(amount: 100, currency: .GBP)  // British Pound
let jpy = Money(amount: 100, currency: .JPY)  // Japanese Yen
let chf = Money(amount: 100, currency: .CHF)  // Swiss Franc
```

### Currency Properties

Each ISO 4217 currency has additional properties:

```swift
let currency = ISO4217Currency.USD

print(currency.alphabeticCode)  // "USD"
print(currency.numericCode)     // "840"
print(currency.minorUnits)      // 2
print(currency.name)            // "United States Dollar"
```

### Finding Currencies

You can look up ISO 4217 currencies by their codes:

```swift
// By alphabetic code
if let dollar = ISO4217Currency(alphabeticCode: "USD") {
    let money = Money(amount: 100, currency: dollar)
}

// By numeric code
if let pound = ISO4217Currency(numericCode: "826") {
    let money = Money(amount: 50, currency: pound)
}
```

## Custom Currencies

### Extending ISO 4217

Add new ISO 4217 currencies that aren't included:

```swift
extension Currency where Self == ISO4217Currency {
    static var XXX: ISO4217Currency {
        .init(
            alphabeticCode: "XXX",
            numericCode: "999",
            minorUnits: 2,
            name: "Test Currency"
        )
    }
}

// Usage
let testMoney = Money(amount: 100, currency: .XXX)
```

### Creating Custom Currency Types

Define completely custom currencies for specialized needs:

```swift
// In-app virtual currencies
struct GameCurrency: Currency, Hashable {
    let id: String
    let minorUnits: Int
    let displayName: String
    let icon: String
}

extension Currency where Self == GameCurrency {
    static var gems: GameCurrency {
        GameCurrency(
            id: "GEMS",
            minorUnits: 0,
            displayName: "Gems",
            icon: "💎"
        )
    }
    
    static var coins: GameCurrency {
        GameCurrency(
            id: "COINS",
            minorUnits: 0,
            displayName: "Coins",
            icon: "🪙"
        )
    }
}

// Usage
let gems = Money(amount: 500, currency: .gems)
let coins = Money(amount: 1000, currency: .coins)
```
