import Foundation
@testable import Money
import Testing

@Suite
struct ExchangeTests {
    // MARK: Exchange Tests

    @Test
    func exchange_whenTradingInvalidSet_doesThrowError() {
        let exchange = MockExchange { _, _ in
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        #expect(throws: MockError.self) {
            try exchange.trade(money, for: .bar)
        }
    }

    @Test
    func exchange_whenTradingValidCurrencyPair_doesConvertMoney() throws {
        let exchange = MockExchange { _, _ in 2 }

        let money = Money(amount: 10.5, currency: .foo)
        let tradedMoney = try exchange.trade(money, for: .bar)

        #expect(tradedMoney == Money(amount: 5.25, currency: .bar))
    }

    @Test
    func exchange_whenTradingValidSet_doesConvertMoney() throws {
        let exchange = MockExchange { _, quote in
            if quote.isEqual(to: .foo) {
                return 2
            } else if quote.isEqual(to: .bar) {
                return 1.25
            } else if quote.isEqual(to: .biz) {
                return 0.75
            } else {
                Issue.record("Invalid test currency sent in.")
                throw MockError()
            }
        }

        let aggregatedMoney = AggregatedMoney([
            Money(amount: 10, currency: .foo), // 5
            Money(amount: 5, currency: .bar), // 4
            Money(amount: 3, currency: .biz), // 4
        ])

        let tradedMoney = try exchange.trade(aggregatedMoney, for: .baz)

        #expect(tradedMoney == Money(amount: 13, currency: .baz))
    }

    @Test
    func exchange_whenTradingMoneyWithSameCurrency_doesNotAskForRate() throws {
        let exchange = MockExchange { _, _ in
            Issue.record("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try exchange.trade(money, for: .foo)
        #expect(money == tradedMoney)
    }

    @Test
    func exchange_whenTradingAggregatedSameWithCurrency_doesNotAskForRate() throws {
        let exchange = MockExchange { _, _ in
            Issue.record("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try exchange.trade(AggregatedMoney(money: money), for: .foo)
        #expect(money == tradedMoney)
    }

    // MARK: AsyncExchange Tests

    @Test
    func asyncExchange_whenTradingInvalidSet_doesThrowError() async {
        let exchange = AsyncMockExchange { _, _ in
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        await #expect(throws: MockError.self) {
            try await exchange.trade(money, for: .bar)
        }
    }

    @Test
    func asyncExchange_whenTradingValidCurrencyPair_doesConvertMoney() async throws {
        let exchange = AsyncMockExchange { _, _ in 2 }

        let money = Money(amount: 10.5, currency: .foo)
        let tradedMoney = try await exchange.trade(money, for: .bar)

        #expect(tradedMoney == Money(amount: 5.25, currency: .bar))
    }

    @Test
    func asyncExchange_whenTradingValidSet_doesConvertMoney() async throws {
        let exchange = AsyncMockExchange { _, quote in
            if quote.isEqual(to: .foo) {
                return 2
            } else if quote.isEqual(to: .bar) {
                return 1.25
            } else if quote.isEqual(to: .biz) {
                return 0.75
            } else {
                Issue.record("Invalid test currency sent in.")
                throw MockError()
            }
        }

        let aggregatedMoney = AggregatedMoney([
            Money(amount: 10, currency: .foo), // 5
            Money(amount: 5, currency: .bar), // 4
            Money(amount: 3, currency: .biz), // 4
        ])

        let tradedMoney = try await exchange.trade(aggregatedMoney, for: .baz)

        #expect(tradedMoney == Money(amount: 13, currency: .baz))
    }

    @Test
    func asyncExchange_whenTradingMoneyWithSameCurrency_doesNotAskForRate() async throws {
        let exchange = AsyncMockExchange { _, _ in
            Issue.record("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try await exchange.trade(money, for: .foo)
        #expect(money == tradedMoney)
    }

    @Test
    func asyncExchange_whenTradingAggregatedSameWithCurrency_doesNotAskForRate() async throws {
        let exchange = AsyncMockExchange { _, _ in
            Issue.record("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try await exchange.trade(AggregatedMoney(money: money), for: .foo)
        #expect(money == tradedMoney)
    }
}
