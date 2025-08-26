# Arithmetic Operations

Perform calculations with monetary values, including operations across different currencies.

## Overview

The Money framework provides comprehensive support for arithmetic operations on monetary values. You can perform operations with scalar values (integers and decimals) or combine monetary values of different currencies using `AggregatedMoney`.

## Operations with Scalars

### Basic Arithmetic

You can perform standard arithmetic operations between `Money` and `Int` or `Decimal` values:

```swift
var balance = Money(amount: 100, currency: .USD)

// Addition and subtraction
balance = balance + 50     // $150
balance += 25              // $175
balance = balance - 75     // $100
balance -= 20              // $80

// Multiplication and division
balance = balance * 2      // $160
balance *= 0.5            // $80
balance = balance / 4     // $20
balance /= 2              // $10

// Negation
balance = -balance        // -$10
```

## Operations Between Money Values

Monetary values cannot simply be added together as that does not account for potentially mismatched currencies, and their exchange rates. Instead, when performing operations on two monetary values, the result is an `AggregatedMoney`. 

```swift
let usd1 = Money(amount: 100, currency: .USD)
let usd2 = Money(amount: 150, currency: .USD)
let gbp = Money(amount: 50, currency: .GBP)
let eur = Money(amount: 75, currency: .EUR)

// Adding different currencies creates AggregatedMoney
let portfolio = usd1 + usd2 + gbp + eur
// Result: AggregatedMoney([.USD: 250, .GBP: 50, .EUR: 75])
```

`AggregatedMoney` maintains a collection of amounts for each currency:

### Building Aggregates

```swift
// Start with one currency
var total = Money(amount: 100, currency: .USD) + Money(amount: 200, currency: .USD)
// Result: AggregatedMoney([.USD: 300])

// Add a different currency
total = total + Money(amount: 50, currency: .GBP)
// Result: AggregatedMoney([.USD: 300, .GBP: 50])

// Continue adding
total += Money(amount: 75, currency: .EUR)
// Result: AggregatedMoney([.USD: 300, .GBP: 50, .EUR: 75])
```

### Subscript Access

Access specific currency amounts directly:

```swift
var portfolio = AggregatedMoney([
    Money(amount: 1000, currency: .USD),
    Money(amount: 500, currency: .EUR)
])

// Read amounts
let usdAmount = portfolio[.USD]  // Optional(1000)
let gbpAmount = portfolio[.GBP]  // nil

// Modify amounts
portfolio[.USD] = 1200  // Update USD amount
portfolio[.JPY] = 50000 // Add new currency
```
