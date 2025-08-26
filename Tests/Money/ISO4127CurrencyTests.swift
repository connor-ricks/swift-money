@testable import Money
import Testing

@Suite
struct ISO4217CurrencyTests {
    @Test
    func alphabeticCodeInitializer_whenInitialized_createsCorrectCurrency() {
        let registry = ISO4217CurrencyRegistry()
        for currency in ISO4217Currency.registry.currencies {
            registry.register(currency)
        }

        #expect(registry.currencies.count == ISO4217Currency.registry.currencies.count)

        for currency in registry.currencies {
            let alphabetic = ISO4217Currency(alphabeticCode: currency.alphabeticCode)
            #expect(alphabetic?.isEqual(to: currency) ?? false)
            #expect(alphabetic?.id == currency.id)
            let numeric = ISO4217Currency(numericCode: currency.numericCode)
            #expect(numeric?.isEqual(to: currency) ?? false)
            #expect(numeric?.id == currency.id)
        }

        #expect(ISO4217Currency(numericCode: "XXX") == nil)
        #expect(ISO4217Currency(alphabeticCode: "XXX") == nil)
    }
}
