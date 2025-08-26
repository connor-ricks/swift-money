# Creating Money

Learn the various ways to create monetary values using the Money framework.

## Overview

The `Money` type represents a monetary value with two essential components: an `amount` and a `currency`. The framework provides multiple initialization methods to accommodate different use cases and data sources.

## Basic Initialization

### From Decimal Amount

The most straightforward way to create money is by specifying an amount and currency:

```swift
let dollars = Money(amount: 10.99, currency: .USD)
let euros = Money(amount: 25.50, currency: .EUR)
let pounds = Money(amount: 100, currency: .GBP)
```

You can use any `Decimal` value for the amount, including negative values:

```swift
let debt = Money(amount: -500, currency: .USD)  // Negative $500
let credit = Money(amount: 250.75, currency: .EUR)  // Positive €250.75
```

## Minor Units

Many currencies have a minor unit - a fractional denomination of the main currency unit. For example, USD has cents (1/100 of a dollar), and GBP has pence (1/100 of a pound).

### Creating from Minor Units

You can initialize money directly from minor units:

```swift
// 5000 cents = $50.00
let fromCents = Money(minorUnits: 5000, currency: .USD)

// 2500 pence = £25.00
let fromPence = Money(minorUnits: 2500, currency: .GBP)
```

### Currencies Without Minor Units

Some currencies, like Japanese Yen (JPY), don't have minor units. For these currencies, the minor units value equals the amount:

```swift
let yenAmount = Money(amount: 1000, currency: .JPY)      // ¥1000
let yenMinor = Money(minorUnits: 1000, currency: .JPY)   // ¥1000 (same value)
```

## Precision and Rounding

The Money framework uses `Decimal` for all monetary calculations to maintain precision. This is critical for financial calculations where `Double` would introduce rounding errors:

### Why Decimal Instead of Double?

Using `Double` for money is problematic because floating-point arithmetic can't accurately represent all decimal values:

```swift
// Problems with Double
let doubleValue = 0.1 + 0.2
print(doubleValue)  // 0.30000000000000004 (not 0.3!)

let price = 19.99
let quantity = 3.0
let total = price * quantity  // 59.96999999999999 (not 59.97!)

// Decimal maintains exact precision
let decimalValue = Decimal(0.1) + Decimal(0.2)
print(decimalValue)  // 0.3 (exact)

let decimalPrice = Decimal(19.99)
let decimalQuantity = Decimal(3)
let decimalTotal = decimalPrice * decimalQuantity  // 59.97 (exact)
```

This precision is essential when dealing with money:
- **Accounting accuracy**: Financial calculations must be exact to the penny
- **Regulatory compliance**: Many jurisdictions require exact decimal arithmetic for financial systems
- **Avoiding compound errors**: Small rounding errors accumulate over many operations
- **Currency conversions**: Exchange rates often have many decimal places

```swift
// Safe monetary calculations with Decimal
let precise = Money(amount: 10.123456789, currency: .USD)

// Round to currency's standard precision (2 decimal places for USD)
var rounded = precise
rounded.round()  // Results in exactly $10.12
```
