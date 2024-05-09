import XCTest
@testable import Money

final class CurrencyTests: XCTestCase {
    func test_isEqual_betweenTwoCurrenciesOfDifferentTypes_isNotEqual() {
        let foo = MockCurrency.foo
        let bar = ISO4217Currency.USD
        XCTAssertFalse(foo.isEqual(to: bar))
    }

    func test_isEqual_betweenTwoDifferentCurrenciesOfSameType_isNotEqual() {
        let foo = MockCurrency.foo
        let bar = MockCurrency.bar
        XCTAssertFalse(foo.isEqual(to: bar))
    }

    func test_isEqual_betweenTwoSameCurrencies_isEqual() {
        XCTAssertTrue(MockCurrency.foo.isEqual(to: .foo))
    }
}
