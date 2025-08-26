@testable import Money
import Testing

@Suite
struct CurrencyTests {
    @Test
    func isEqual_betweenTwoCurrenciesOfDifferentTypes_isNotEqual() {
        let foo = MockCurrency.foo
        let bar = ISO4217Currency.USD
        #expect(foo.isEqual(to: bar) == false)
    }

    @Test
    func isEqual_betweenTwoDifferentCurrenciesOfSameType_isNotEqual() {
        let foo = MockCurrency.foo
        let bar = MockCurrency.bar
        #expect(foo.isEqual(to: bar) == false)
    }

    @Test
    func isEqual_betweenTwoSameCurrencies_isEqual() {
        #expect(MockCurrency.foo.isEqual(to: .foo) == true)
    }
}
