@testable import Money
import XCTest

final class ExchangeTests: XCTestCase {

    // MARK: Exchange Tests

    func test_exchange_whenTradingInvalidSet_doesThrowError() {
        let exchange = MockExchange { _, _ in
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        XCTAssertThrowsError(try exchange.trade(money, for: .bar)) { error in
            XCTAssertTrue(error is MockError)
        }
    }

    func test_exchange_whenTradingValidCurrencyPair_doesConvertMoney() throws {
        let exchange = MockExchange { _, _ in 2 }

        let money = Money(amount: 10.5, currency: .foo)
        let tradedMoney = try exchange.trade(money, for: .bar)

        XCTAssertEqual(tradedMoney, Money(amount: 5.25, currency: .bar))
    }

    func test_exchange_whenTradingValidSet_doesConvertMoney() throws {
        let exchange = MockExchange { _, quote in
            if quote.isEqual(to: .foo) {
                return 2
            } else if quote.isEqual(to: .bar) {
                return 1.25
            } else if quote.isEqual(to: .biz) {
                return 0.75
            } else {
                XCTFail("Invalid test currenct sent in.")
                throw MockError()
            }
        }

        let aggregatedMoney = AggregatedMoney([
            Money(amount: 10, currency: .foo), // 5
            Money(amount: 5, currency: .bar),  // 4
            Money(amount: 3, currency: .biz),  // 4
        ])

        let tradedMoney = try exchange.trade(aggregatedMoney, for: .baz)

        XCTAssertEqual(tradedMoney, Money(amount: 13, currency: .baz))
    }

    func test_exchange_whenTradingMoneyWithSameCurrency_doesNotAskForRate() throws {
        let exchange = MockExchange { _, _ in
            XCTFail("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try exchange.trade(money, for: .foo)
        XCTAssertEqual(money, tradedMoney)
    }

    func test_exchange_whenTradingAggregatedSameWithCurrency_doesNotAskForRate() throws {
        let exchange = MockExchange { _, _ in
            XCTFail("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try exchange.trade(AggregatedMoney(money: money), for: .foo)
        XCTAssertEqual(money, tradedMoney)
    }

    // MARK: AsyncExchange Tests

    func test_asyncExchange_whenTradingInvalidSet_doesThrowError() async {
        let exchange = AsyncMockExchange { _, _ in
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        do {
            _ = try await exchange.trade(money, for: .bar)
            XCTFail("Expected trade to throw an error.")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }

    func test_asyncExchange_whenTradingValidCurrencyPair_doesConvertMoney() async throws {
        let exchange = AsyncMockExchange { _, _ in 2 }

        let money = Money(amount: 10.5, currency: .foo)
        let tradedMoney = try await exchange.trade(money, for: .bar)

        XCTAssertEqual(tradedMoney, Money(amount: 5.25, currency: .bar))
    }

    func test_asyncExchange_whenTradingValidSet_doesConvertMoney() async throws {
        let exchange = AsyncMockExchange { _, quote in
            if quote.isEqual(to: .foo) {
                return 2
            } else if quote.isEqual(to: .bar) {
                return 1.25
            } else if quote.isEqual(to: .biz) {
                return 0.75
            } else {
                XCTFail("Invalid test currenct sent in.")
                throw MockError()
            }
        }

        let aggregatedMoney = AggregatedMoney([
            Money(amount: 10, currency: .foo), // 5
            Money(amount: 5, currency: .bar),  // 4
            Money(amount: 3, currency: .biz),  // 4
        ])

        let tradedMoney = try await exchange.trade(aggregatedMoney, for: .baz)

        XCTAssertEqual(tradedMoney, Money(amount: 13, currency: .baz))
    }

    func test_asyncExchange_whenTradingMoneyWithSameCurrency_doesNotAskForRate() async throws {
        let exchange = AsyncMockExchange { _, _ in
            XCTFail("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try await exchange.trade(money, for: .foo)
        XCTAssertEqual(money, tradedMoney)
    }

    func test_asyncExchange_whenTradingAggregatedSameWithCurrency_doesNotAskForRate() async throws {
        let exchange = AsyncMockExchange { _, _ in
            XCTFail("Conversion between same currencies should not ask for a rate")
            throw MockError()
        }

        let money = Money(amount: 10, currency: .foo)
        let tradedMoney = try await exchange.trade(AggregatedMoney(money: money), for: .foo)
        XCTAssertEqual(money, tradedMoney)
    }
}
