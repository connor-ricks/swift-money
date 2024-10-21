@testable import Money
import XCTest

final class ISO4217CurrencyTests: XCTestCase {
    func test_alphabeticCodeInitializer_whenInitialized_createsCorrectCurrency() {
        for currency in ISO4217Currency.allCases {
            let alphabetic = ISO4217Currency(alphabeticCode: currency.alphabeticCode)
            XCTAssertTrue(alphabetic?.isEqual(to: currency) ?? false)
            XCTAssertTrue(alphabetic?.id == currency.id)
            let numeric = ISO4217Currency(numericCode: currency.numericCode)
            XCTAssertTrue(numeric?.isEqual(to: currency) ?? false)
            XCTAssertTrue(numeric?.id == currency.id)
        }

        XCTAssertNil(ISO4217Currency(numericCode: "XXX"))
        XCTAssertNil(ISO4217Currency(alphabeticCode: "XXX"))
    }
}
