import Foundation
@testable import Money
import Testing

// swiftlint:disable shorthand_operator

@Suite
struct AggregatedMoneyTests {
    // MARK: Initialization Tests

    @Test
    func aggregatedMoney_whenInitializedMatchesParameters() {
        let foo = AggregatedMoney()
        #expect(foo == AggregatedMoney(amounts: [:]))

        let bar = AggregatedMoney(amount: 1.5, currency: .bar)
        #expect(bar == AggregatedMoney(amounts: [
            .init(.bar): 1.5
        ]))

        let biz = AggregatedMoney(minorUnits: 1_000, currency: .biz)
        #expect(biz == AggregatedMoney(amounts: [
            .init(.biz): 10
        ]))

        let baz = AggregatedMoney(
            money: Money(amount: 1.5, currency: .foo),
            Money(amount: 2.0, currency: .foo),
            Money(amount: 1, currency: .bar),
            Money(amount: 1, currency: .bar),
            Money(amount: 3, currency: .baz)
        )
        #expect(baz == AggregatedMoney(amounts: [
            .init(.foo): 3.5,
            .init(.bar): 2,
            .init(.baz): 3,
        ]))

        let bez = AggregatedMoney([
            Money(amount: 1.5, currency: .foo),
            Money(amount: 2.0, currency: .foo),
            Money(amount: 1, currency: .bar),
            Money(amount: 1, currency: .bar),
            Money(amount: 3, currency: .baz),
        ])

        #expect(bez == AggregatedMoney(amounts: [
            .init(.foo): 3.5,
            .init(.bar): 2,
            .init(.baz): 3,
        ]))

        let waz = AggregatedMoney(
            aggregatedMoney: AggregatedMoney(amount: 1.5, currency: .foo),
            AggregatedMoney(amount: 2.0, currency: .foo),
            AggregatedMoney(amount: 1, currency: .bar),
            AggregatedMoney(amount: 1, currency: .bar),
            AggregatedMoney(amount: 3, currency: .baz)
        )

        #expect(waz == AggregatedMoney(amounts: [
            .init(.foo): 3.5,
            .init(.bar): 2,
            .init(.baz): 3,
        ]))

        let wez = AggregatedMoney([
            AggregatedMoney(amount: 1.5, currency: .foo),
            AggregatedMoney(amount: 2.0, currency: .foo),
            AggregatedMoney(amount: 1, currency: .bar),
            AggregatedMoney(amount: 1, currency: .bar),
            AggregatedMoney(amount: 3, currency: .baz),
        ])

        #expect(wez == AggregatedMoney(amounts: [
            .init(.foo): 3.5,
            .init(.bar): 2,
            .init(.baz): 3,
        ]))
    }

    // MARK: Subscript Tests

    @Test
    func aggregatedMoneySubscript_whenCurrencyExists_returnsCurrency() {
        let foo = AggregatedMoney(amount: 10, currency: .foo)
        #expect(foo[.foo] == 10)
    }

    @Test
    func aggregatedMoneySubscript_whenCurrencyDoesNotExist_returnsNil() {
        let foo = AggregatedMoney(amount: 10, currency: .foo)
        #expect(foo[.biz] == nil)
    }

    @Test
    func aggregatedMoneySubscript_whenCurrencyExistsAndIsAssigned_overridesValue() {
        var foo = AggregatedMoney(amount: 10, currency: .foo)
        foo[.foo] = 5
        #expect(foo[.foo] == 5)
    }

    @Test
    func aggregatedMoneySubscript_whenCurrencyExistsAndIsRemoved_nilsValue() {
        var foo = AggregatedMoney(amount: 10, currency: .foo)
        foo[.foo] = nil
        #expect(foo[.foo] == nil)
    }

    @Test
    func aggregatedMoneySubscript_whenCurrencyDoesNotExistAndIsAssigned_setsValue() {
        var foo = AggregatedMoney(amount: 10, currency: .foo)
        foo[.baz] = 5
        #expect(foo == AggregatedMoney([
            Money(amount: 10, currency: .foo),
            Money(amount: 5, currency: .baz),
        ]))
    }

    // MARK: Subscript Default Tests

    @Test
    func aggregatedMoneySubscriptWithDefault_whenCurrencyExists_returnsCurrency() {
        let foo = AggregatedMoney(amount: 10, currency: .foo)
        #expect(foo[.foo, default: 0] == 10)
    }

    @Test
    func aggregatedMoneySubscriptWithDefault_whenCurrencyDoesNotExist_returnsDefault() {
        let foo = AggregatedMoney(amount: 10, currency: .foo)
        #expect(foo[.biz, default: 2] == 2)
    }

    @Test
    func aggregatedMoneySubscriptWithDefault_whenCurrencyExistsAndIsAssigned_overridesValue() {
        var foo = AggregatedMoney(amount: 10, currency: .foo)
        foo[.foo, default: 2] = 5
        #expect(foo[.foo] == 5)
    }

    @Test
    func aggregatedMoneySubscriptWithDefault_whenCurrencyDoesNotExistAndIsAssigned_setsValue() {
        var foo = AggregatedMoney(amount: 10, currency: .foo)
        foo[.baz, default: 2] = 5
        #expect(foo == AggregatedMoney([
            Money(amount: 10, currency: .foo),
            Money(amount: 5, currency: .baz),
        ]))
    }

    // MARK: Conversion Tests

    @Test
    func aggregatedMoney_whenConvertedToMoneyUsingExchange_outputMatchesExchangeOutput() throws {
        let exchange = MockExchange { _, quote in
            if quote.isEqual(to: .foo) {
                return 0.5
            } else if quote.isEqual(to: .bar) {
                return 2.0
            } else {
                Issue.record("Unexpected currency sent through exchange for test.")
                throw MockError()
            }
        }

        let aggregatedMoney = AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar),
        ])

        let converted = try aggregatedMoney.converted(to: .baz, using: exchange)
        let traded = try exchange.trade(aggregatedMoney, for: .baz)
        #expect(converted == traded)
    }

    @Test
    func aggregatedMoney_whenConvertedToMoneyUsingAsyncExchange_outputMatchesAsyncExchangeOutput() async throws {
        let exchange = AsyncMockExchange { _, quote in
            if quote.isEqual(to: .foo) {
                return 0.5
            } else if quote.isEqual(to: .bar) {
                return 2.0
            } else {
                Issue.record("Unexpected currency sent through exchange for test.")
                throw MockError()
            }
        }

        let aggregatedMoney = AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar),
        ])

        let converted = try await aggregatedMoney.converted(to: .baz, using: exchange)
        let traded = try await exchange.trade(aggregatedMoney, for: .baz)
        #expect(converted == traded)
    }

    // MARK: Arithmetic Tests

    @Test
    func aggregatedMoney_whenAddedWithAggregatedMoney_createsAggregatedMoney() {
        var foo = AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar),
        ])

        foo = foo + AggregatedMoney([
            Money(amount: 1, currency: .bar),
            Money(amount: 3, currency: .baz),
        ])

        #expect(foo == AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 2, currency: .bar),
            Money(amount: 3, currency: .baz),
        ]))

        foo += AggregatedMoney([
            Money(amount: 2, currency: .foo),
            Money(amount: 2, currency: .biz),
        ])

        #expect(foo == AggregatedMoney([
            Money(amount: 3, currency: .foo),
            Money(amount: 2, currency: .bar),
            Money(amount: 3, currency: .baz),
            Money(amount: 2, currency: .biz),
        ]))
    }

    @Test
    func aggregatedMoney_whenAddedWithMoney_createsAggregatedMoney() {
        var foo = AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar),
        ])

        foo = foo + Money(amount: 3, currency: .bar)
        #expect(foo == AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 4, currency: .bar),
        ]))

        foo = Money(amount: 2, currency: .baz) + foo

        #expect(foo == AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 4, currency: .bar),
            Money(amount: 2, currency: .baz),
        ]))

        foo += Money(amount: 3, currency: .foo)
        foo += Money(amount: 3, currency: .biz)

        #expect(foo == AggregatedMoney([
            Money(amount: 4, currency: .foo),
            Money(amount: 4, currency: .bar),
            Money(amount: 2, currency: .baz),
            Money(amount: 3, currency: .biz),
        ]))
    }

    @Test
    func aggregatedMoney_whenSubtractedWithMoney_createsAggregatedMoney() {
        var foo = AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar),
        ])

        foo = foo - Money(amount: 3, currency: .bar)
        #expect(foo == AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: -2, currency: .bar),
        ]))

        foo = Money(amount: 2, currency: .baz) - foo

        #expect(foo == AggregatedMoney([
            Money(amount: -1, currency: .foo),
            Money(amount: 2, currency: .bar),
            Money(amount: 2, currency: .baz),
        ]))

        foo -= Money(amount: 1, currency: .foo)
        foo -= Money(amount: -3, currency: .biz)

        #expect(foo == AggregatedMoney([
            Money(amount: -2, currency: .foo),
            Money(amount: 2, currency: .bar),
            Money(amount: 2, currency: .baz),
            Money(amount: 3, currency: .biz),
        ]))
    }

    @Test
    func aggregatedMoney_whenSubractedWithAggregatedMoney_createsAggregatedMoney() {
        var foo = AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar),
        ])

        foo = foo - AggregatedMoney([
            Money(amount: 1, currency: .bar),
            Money(amount: 3, currency: .baz),
        ])

        #expect(foo == AggregatedMoney([
            Money(amount: 1, currency: .foo),
            Money(amount: 0, currency: .bar),
            Money(amount: -3, currency: .baz),
        ]))

        foo -= AggregatedMoney([
            Money(amount: 2, currency: .foo),
            Money(amount: 2, currency: .biz),
        ])

        #expect(foo == AggregatedMoney([
            Money(amount: -1, currency: .foo),
            Money(amount: 0, currency: .bar),
            Money(amount: -3, currency: .baz),
            Money(amount: -2, currency: .biz),
        ]))
    }

    @Test
    func aggregatedMoney_whenMultiplied_createsAggregatedMoney() {
        var foo = AggregatedMoney([
            Money(amount: 2, currency: .foo),
            Money(amount: -3, currency: .bar),
        ])

        foo = foo * 3

        #expect(foo == AggregatedMoney([
            Money(amount: 6, currency: .foo),
            Money(amount: -9, currency: .bar),
        ]))

        foo = foo * -2

        #expect(foo == AggregatedMoney([
            Money(amount: -12, currency: .foo),
            Money(amount: 18, currency: .bar),
        ]))

        foo *= -1

        #expect(foo == AggregatedMoney([
            Money(amount: 12, currency: .foo),
            Money(amount: -18, currency: .bar),
        ]))

        foo = foo * Decimal(3)

        #expect(foo == AggregatedMoney([
            Money(amount: 36, currency: .foo),
            Money(amount: -54, currency: .bar),
        ]))

        foo = foo * Decimal(-2)

        #expect(foo == AggregatedMoney([
            Money(amount: -72, currency: .foo),
            Money(amount: 108, currency: .bar),
        ]))

        foo *= Decimal(-1)

        #expect(foo == AggregatedMoney([
            Money(amount: 72, currency: .foo),
            Money(amount: -108, currency: .bar),
        ]))
    }

    @Test
    func aggregatedMoney_whenDivided_createsAggregatedMoney() {
        var foo = AggregatedMoney([
            Money(amount: 100, currency: .foo),
            Money(amount: -50, currency: .bar),
        ])

        foo = foo / 2

        #expect(foo == AggregatedMoney([
            Money(amount: 50, currency: .foo),
            Money(amount: -25, currency: .bar),
        ]))

        foo = foo / -1

        #expect(foo == AggregatedMoney([
            Money(amount: -50, currency: .foo),
            Money(amount: 25, currency: .bar),
        ]))

        foo /= 5

        #expect(foo == AggregatedMoney([
            Money(amount: -10, currency: .foo),
            Money(amount: 5, currency: .bar),
        ]))

        foo /= Decimal(2)

        #expect(foo == AggregatedMoney([
            Money(amount: -5, currency: .foo),
            Money(amount: 2.5, currency: .bar),
        ]))

        foo /= Decimal(-1)

        #expect(foo == AggregatedMoney([
            Money(amount: 5, currency: .foo),
            Money(amount: -2.5, currency: .bar),
        ]))
    }

    @Test
    func aggregatedMoney_whenNegated_doesNegateAmounts() {
        var foo = AggregatedMoney([
            Money(amount: 5, currency: .foo),
            Money(amount: -10, currency: .bar),
        ])

        foo = -foo

        #expect(foo == AggregatedMoney([
            Money(amount: -5, currency: .foo),
            Money(amount: 10, currency: .bar),
        ]))
    }
}

// swiftlint:enable shorthand_operator
