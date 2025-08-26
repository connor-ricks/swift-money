# Getting Started

Learn the basics of working with monetary values using the Money framework.

## Overview

The Money framework provides a flexible approach to handling monetary values that works well with dynamic, multi-currency applications. Unlike generic-based approaches that require compile-time knowledge of currencies, Money allows you to work with different currencies at runtime while still maintaining safety and precision.

## Why Not Generics?

A common approach to monetary values might look like `Money<USD>`, using generics to enforce type safety. While this works well for single-currency applications, it quickly becomes problematic when dealing with multiple currencies:

```swift
// This approach requires everything to be generic
struct Receipt<C: Currency> {
    let amount: Money<C>
}

// Which bubbles up through your entire codebase
struct ExpenseReport<C: Currency> {
    let receipts: [Receipt<C>]
}
```

This pattern doesn't scale well when dealing with real-world scenarios like:
- API responses with mixed currencies
- International transactions
- Dynamic currency selection

## The Money Approach

Instead, Money uses a runtime-based approach that maintains safety while allowing flexibility:

```swift
// Create money with any currency
let usd = Money(amount: 100, currency: .USD)
let gbp = Money(amount: 50, currency: .GBP)
let jpy = Money(amount: 1000, currency: .JPY)

// Store different currencies together
let receipts = [usd, gbp, jpy]

// Aggregate multiple currencies
let total = usd + gbp + jpy  // Creates AggregatedMoney
```

## Why Decimal, Not Double?

The Money framework uses `Decimal` instead of `Double` for all monetary amounts. This is a critical design decision for financial software:

```swift
// The problem with Double
let doubleResult = 0.1 + 0.2
print(doubleResult)  // 0.30000000000000004 ❌

// Decimal gives exact results
let decimalResult = Decimal(0.1) + Decimal(0.2)
print(decimalResult)  // 0.3 ✅

// Real-world example: calculating invoice totals
let itemPrice = 19.99
let taxRate = 0.0825
let doubleTax = itemPrice * taxRate      // 1.6491749999999998
let decimalTax = Decimal(19.99) * Decimal(0.0825)  // 1.649175 (exact)
```

This precision matters because:
- Financial calculations must be accurate to the smallest unit (penny, cent, etc.)
- Rounding errors compound over multiple operations
- Regulatory requirements often mandate exact decimal arithmetic
- Customer trust depends on accurate monetary calculations

## Basic Usage

### Creating Money

```swift
import Money

// Create from amount
let dollars = Money(amount: 10.50, currency: .USD)

// Create from minor units (cents for USD)
let fromCents = Money(minorUnits: 1050, currency: .USD)  // Also $10.50

// For currencies without minor units
let yen = Money(amount: 1000, currency: .JPY)
let yenMinor = Money(minorUnits: 1000, currency: .JPY)  // Same value
```

### Basic Operations

```swift
var balance = Money(amount: 100, currency: .USD)

// Add and subtract amounts
balance = balance + 50  // $150
balance -= 25          // $125

// Multiply and divide
balance = balance * 2   // $250
balance /= 5           // $50
```

