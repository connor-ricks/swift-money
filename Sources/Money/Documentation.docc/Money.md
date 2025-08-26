# ``Money``

A precise, flexible representation of monetary values in any given currency.

## Overview

Rather than using a concrete generic type to enforce type safety and help prevent user error when dealing with monetary values across different currencies, Money introduces various concepts and guard rails to prevent abuse, while still allowing for the flexibility of dealing with dynamic values of various currencies.

The Money framework provides a robust solution for handling monetary values across multiple currencies without the limitations of generic-based approaches. It introduces smart abstractions like `AggregatedMoney` to handle multi-currency operations and provides flexible conversion mechanisms through exchange protocols.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:CreatingMoney>
- <doc:ArithmeticOperations>
- <doc:CurrencyConversion>
- <doc:WorkingWithCurrencies>
