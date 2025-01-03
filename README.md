# 💰 Money
![Build](https://img.shields.io/github/actions/workflow/status/connor-ricks/swift-money/checks.yaml?logo=GitHub)
![Codecov](https://img.shields.io/codecov/c/github/connor-ricks/swift-money?logo=Codecov&label=codecov)
![License](https://img.shields.io/github/license/connor-ricks/swift-money?color=blue)

A precise, flexible representation of monetary values in any given currency.

## Overview

Rather than using a concrete generic type to enforce type safety and help 
prevent user error when dealing with monetary values across different 
currencies, Money introduces various concepts and guard rails to prevent abuse,
while still allowing for the flexibility of dealing with dynamic values of 
various currencies.

A common way of defining a monetary value would be something similar to 
`Money<USD>`. At the surface level this seems like a great solution. It allows
you to utilize the compiler prevent abuse. A perfect example would be attempting 
to add `Money<USD>` and `Money<GBP>`. You cannot simply add a monetary value of 
two currencies, you must convert one of the currenices to the currency of the 
other value before adding their amounts together. Using generics, you are able 
to restrict these operations and prevent yourself from making mistakes.

This strategy works great when you are dealing with one currency throughout your
entire application, but it falls apart quickly when you introduce support for 
multiple currencies.

Take the following example...

Say you are writing an app that keeps track of expenses for employees, and you 
need to display a list of receipts, as well as their total value. Your API may 
return an array of monetary values of various currencies. 

(Imagine an employee on a business trip abroad)

```json
{
  "receipts": [
    {
      "name": "Airport Dinner",
      "amount": "38.50",
      "currency": "USD"
    }, {
      "name": "Hotel",
      "amount": "200",
      "currency": "GBP"
    }, {
      "name": "Public Transportation",
      "amount": "5",
      "currency": "GBP"
    }
  ]
}
```

Given that the list of receipts contains different currencies, decoding the 
receipts into a generic typed `Money<USD>` would not be feasible. The app would 
either have to convert all money to `USD` using a custom decoder, or know 
exactly what type of money the API will send ahead of time.

Even if all the receipts for a given request used the same currency, that would 
mean that you would have to define your receipt using generics too, as other 
request could return recipets with different currencies.

```swift
struct Receipt<C: Currency> {
    let amount: Money<C>
}
```

Sadly, this doesn't scale well, as anything that interacts with a `Receipt` will
also need to be generic over a monetary value, bubbling up through your entire 
code base until everything is generic over your currency type.

## Usage

Learn how to use Money in your project.

### Creating Money

The `Money` type contains a `currency`, and an `amount`, representing the amount
of the given currency that the monetary value contains. Predefined currencies 
are named using their [ISO 4217](https://www.iso.org/iso-4217-currency-codes.html) 
currency code.

```swift
let dollars = Money(amount: 10, currency: .USD) // $10
```

Some currencies specify a minor unit, for example, `USD` amounts utilize cents,
with each cent being worth 1/100 of a dollar. You can initialize monetary values 
from a quantity of minor units. For currencies that have no minor units, 
like `JPY`, the value would be the same as if the standard `amount` initializer 
would have been used.

```swift
let dollars = Money(minorUnits: 50, currency: .USD) // $0.50

let foo = Money(amount: 2000, currency: .JPY) // ¥2000
let bar = Money(minorUnits: 2000, currency: .JPY) // ¥2000
```

### Arithmetic

#### `Int` and `Decimal`

Performing simple arithmetic operations on `Money` is as easy as using operators
like `+`, `+=`, `-`, `-=`, `*`, `*=`, `/`, `/=` with either `Int` or `Decimal` 
values.

```swift
var dollars = Money(amount: 10, currency: .USD)
dollars = dollars + 3 // Money(amount:  13, currency: .USD)
dollars += 2          // Money(amount:  15, currency: .USD)

dollars = dollars - 5 // Money(amount:  10, currency: .USD)
dollars -= -10        // Money(amount:  20, currency: .USD)

dollars = dollars * 2 // Money(amount:  40, currency: .USD)
dollars *= -1         // Money(amount: -40, currency: .USD)

dollars = dollars / 2 // Money(amount: -20, currency: .USD)
dollars /= -1         // Money(amount:  20, currency: .USD)

dollars = -dollars    // Money(amount: -20, currency: .USD)
```

#### `Money`

Performing arithmetic operations on two `Money` objects is a little more nuanced 
than simply operating on their amounts. Two monetary values could have different 
currencies, which means they would need to be converted to the same currency 
before performing operations on their amounts. Rather than requiring that all 
operations between monetary values provide an exchange rate, we introduce the 
concept of `AggregatedMoney`

`AggregatedMoney` is backed by a collection of monetary values, effectively 
delaying the need to convert currencies until you need to.

```swift
let dollars =  Money(amount: 10, currency: .USD)
let sterling = Money(amount:  5, currency: .GBP)

var aggregatedMoney = dollars + sterling             // AggregatedMoney([.USD: 10, .GBP:  5])
aggregatedMoney += Money(amount: 20, currency: .GBP) // AggregatedMoney([.USD: 10, .GBP: 25])
aggregatedMoney -= Money(amount: 10, currency: .JPY) // AggregatedMoney([.USD: 10, .GBP: 25, .JPY: -10])

aggregatedMoney *=  5 // AggregatedMoney([.USD: 50, .GBP: 125, .JPY: -50])
aggregatedMoney /= 25 // AggregatedMoney([.USD:  2, .GBP:   5, .JPY:  -2])

let otherAggregatedMoney = AggregatedMoney([Money(amount: 5, currency: .GBP), Money(amount: 10, currency: .EUR)])

aggregatedMoney += otherAggregatedMoney // AggregatedMoney([.USD: 2, .GBP: 10, .JPY: -2, .EUR: 10])

aggregatedMoney = -aggregatedMoney // AggregatedMoney([.USD: -2, .GBP: -10, .JPY: 2, .EUR: -10])
```

### Conversion

For quick simple exchanges, `Money` exposes a `convert` and 
`converted` function that simply takes a `rate` and performs the conversion 
directly.

```swift
let dollars = Money(amount: 10, currency: .USD) // $10
let sterling = dollars.converted(to: .GBP, rate: 1.25) // $8
```

#### Exchanges

Another option to convert one monetary value to another, is making use of 
either an `Exchange` or an `AsyncExchange`

Both exchanges are protocols that require the implementation of a `rate` 
function that provides an exchange rate for a given `base` currency and `quote` 
currency. The `rate` function is a throwing function as your exchange may 
perform some failable work, such as a network request, or it may not support 
converting between all possible currencies.

How you choose to implement an exchange is up to you. You could choose an 
`Exchange` with a set number of exchange rates at initialization, or you could 
utilize `AsyncExchange` to fetch the latest exchange rate for a given currency 
pair upon request. This framework does not provide any concrete exchange 
implementations as the requirements for the consumer depend on their specific 
use case.

Once you have an exchange, utilizing it for `Money` is very simple.

```swift
let exchange = ForexExchange(...) // GBP/USD = 1.25
let dollars = Money(amount: 10, currency: .USD) // $10
let sterling = try await exchange.trade(dollars, for: .GBP) // £8
```

For `AggregatedMoney`, you are exchanging each currency in the collection to the 
desired currency and summing their values.

```swift
let exchange = ForexExchange(...) // GBP/USD = 1.25 GBP/EUR 1.15
let dollars = Money(amount: 10, currency: .USD) // $10
let euros = Money(amount: 100, currency: .EUR) // €23
let aggregatedMoney = AggregatedMoney(money: dollars, euros)
let sterling = try await exchange.trade(aggregatedMoney, for: .GBP) // £28
```

### Rounding

`Money` can be rounded using its `currency` to determine the level of prevision.

```swift
var dollars = Money(amount: 5.5555, currency: .USD)
dollars.round() // $5.56
```

### AggregatedMoney Subscripting

Sometimes, you may want to interact directly with the amount of a specific monetary value within an `AggregatedMoney`. To do so, you can utilize subscripting to get and set amounts for a given currency.

```swift
var aggregatedMoney = AggregatedMoney(money: Money(amount: 10, currency: .USD), Money(amount: 15, currency: .GBP))
let dollarsAmount = aggregatedMoney[.USD] // 10
let yenAmount = aggregatedMoney[.JPY] // nil

aggregatedMoney[.USD] = 15 // AggregatedMoney(money: Money(amount: 15, currency: .USD), Money(amount: 15, currency: .GBP))
```

### Supported Currencies

Out of the box, this framework has predefined currencies for most ISO 4217 currencies. You can reference them using their alphabetic code as static properties on `Currency`

```swift
let dollars = Money(amount: 10, currency: .USD)
let sterling = Money(amount: 10, currency: .GBP)
```

In addition, you can attempt to initialize an `ISO4217Currency` using either an alphabetic code or numeric code.

```swift
let dollar = ISO4217Currency(alphabeticCode: "USD") // Optional<ISO4217Currency>(.GBP)
let sterling = ISO4217Currency(numericCode: "826")  // Optional<ISO4217Currency>(.GBP)
```

These initializers will only work for currencies defined within the framework. If you extend `ISO4217Currency` beyond the predefined currencies, they will not successfully be decoded by the initializers.

#### Custom Currencies

While this framework comes prepopulated with a fair number of currencies, there are times in which you many need to add your own, either new ISO 4217 currencies or perhaps even your own custom currencies.

Creating a new `ISO4217Currency` is as easy as extending the static properties that already exist on `Currency`.

```swift
extension Currency where Self == ISO4217Currency {
    static var XXX: ISO4217Currency { .init(alphabeticCode: "XXX", numericCode: "000", minorUnits: 2, name: "Some Currency") }
}

let money = Money(amount: 10, currency: .XXX)
```

If you have your own custom currency, for example maybe an in-app currency such as 💎s, you could create your own currency by conforming to `Currency`.

```swift
struct InAppCurrency: Currency {
    let id: String
    let minorUnits: Int = 0
}

extension Currency where Self == InAppCurrency {
    static var diamonds: InAppCurrency { .init(id: "💎", minorUnits: 0) }
    static var hearts: InAppCurrency { .init(id: "❤️", minorUnits: 1) }
}
```
