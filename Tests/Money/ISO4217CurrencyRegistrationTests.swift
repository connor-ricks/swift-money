import Foundation
@testable import Money
import Testing

@Suite
struct ISO4217CurrencyRegistrationTests {

    // MARK: - Test Helpers

    private func createTestCurrency(alpha: String = "XXX", numeric: String = "999", minorUnits: Int = 2, name: String = "Test Currency") -> ISO4217Currency {
        ISO4217Currency(alphabeticCode: alpha, numericCode: numeric, minorUnits: minorUnits, name: name)
    }

    // MARK: - Registration Tests

    @Test
    func registerCurrency_whenNewCurrencyRegistered_canBeRetrievedByAlphabeticCode() {
        let registry = ISO4217CurrencyRegistry()
        let customCurrency = createTestCurrency(alpha: "TST", numeric: "998")
        registry.register(customCurrency)

        let retrieved = ISO4217Currency(alphabeticCode: "TST", using: registry)
        #expect(retrieved == customCurrency)
    }

    @Test
    func registerCurrency_whenNewCurrencyRegistered_canBeRetrievedByNumericCode() {
        let registry = ISO4217CurrencyRegistry()
        let customCurrency = createTestCurrency(alpha: "NUM", numeric: "997", minorUnits: 3)
        registry.register(customCurrency)

        let retrieved = ISO4217Currency(numericCode: "997", using: registry)
        #expect(retrieved == customCurrency)
    }

    @Test
    func unregisterCurrency_whenCurrencyUnregistered_cannotBeRetrieved() {
        let registry = ISO4217CurrencyRegistry()
        let customCurrency = createTestCurrency(alpha: "REM", numeric: "996")

        registry.register(customCurrency)
        #expect(ISO4217Currency(alphabeticCode: "REM", using: registry) != nil)
        #expect(ISO4217Currency(numericCode: "996", using: registry) != nil)

        registry.unregister(customCurrency)
        #expect(ISO4217Currency(alphabeticCode: "REM", using: registry) == nil)
        #expect(ISO4217Currency(numericCode: "996", using: registry) == nil)
    }

    @Test
    func registerCurrency_whenCurrencyReregistered_overwritesPreviousRegistration() {
        let registry = ISO4217CurrencyRegistry()
        let currency1 = createTestCurrency(alpha: "OVR", numeric: "995", minorUnits: 2, name: "Original")
        let currency2 = createTestCurrency(alpha: "OVR", numeric: "995", minorUnits: 4, name: "Updated")

        registry.register(currency1)
        let retrieved1 = ISO4217Currency(alphabeticCode: "OVR", using: registry)
        #expect(retrieved1 == currency1)

        registry.register(currency2)
        let retrieved2 = ISO4217Currency(alphabeticCode: "OVR", using: registry)
        #expect(retrieved2 == currency2)
    }

    // MARK: - Currencies Property Tests

    @Test
    func registryCurrencies_whenCurrenciesRegistered_returnsAllRegisteredCurrencies() {
        let registry = ISO4217CurrencyRegistry()
        let currency1 = createTestCurrency(alpha: "AA1", numeric: "991", name: "Currency 1")
        let currency2 = createTestCurrency(alpha: "AA2", numeric: "992", name: "Currency 2")
        let currency3 = createTestCurrency(alpha: "AA3", numeric: "993", name: "Currency 3")

        #expect(registry.currencies.isEmpty)

        registry.register(currency1)
        registry.register(currency2)
        registry.register(currency3)

        let currentCurrencies = registry.currencies
        #expect(currentCurrencies == [
            currency1,
            currency2,
            currency3,
        ])
    }

    @Test
    func registryCurrencies_whenCurrencyUnregistered_updatesSet() {
        let registry = ISO4217CurrencyRegistry()
        let currency = createTestCurrency(alpha: "UPD", numeric: "994")

        registry.register(currency)
        #expect(registry.currencies == [currency])

        registry.unregister(currency)
        #expect(registry.currencies.isEmpty)
    }

    @Test
    func registerCurrency_whenConflictingNumericCode_removesOrphanedAlphabeticEntry() {
        let registry = ISO4217CurrencyRegistry()
        let currency1 = createTestCurrency(alpha: "ABC", numeric: "123", name: "First Currency")
        let currency2 = createTestCurrency(alpha: "XYZ", numeric: "123", name: "Second Currency")

        registry.register(currency1)
        #expect(ISO4217Currency(alphabeticCode: "ABC", using: registry) == currency1)
        #expect(ISO4217Currency(numericCode: "123", using: registry) == currency1)

        registry.register(currency2)
        #expect(ISO4217Currency(alphabeticCode: "ABC", using: registry) == nil)
        #expect(ISO4217Currency(alphabeticCode: "XYZ", using: registry) == currency2)
        #expect(ISO4217Currency(numericCode: "123", using: registry) == currency2)
        #expect(registry.currencies == [currency2])
    }

    @Test
    func registerCurrency_whenConflictingAlphabeticCode_removesOrphanedNumericEntry() {
        let registry = ISO4217CurrencyRegistry()
        let currency1 = createTestCurrency(alpha: "ABC", numeric: "123", name: "First Currency")
        let currency2 = createTestCurrency(alpha: "ABC", numeric: "456", name: "Second Currency")

        registry.register(currency1)
        #expect(ISO4217Currency(alphabeticCode: "ABC", using: registry) == currency1)
        #expect(ISO4217Currency(numericCode: "123", using: registry) == currency1)

        registry.register(currency2)
        #expect(ISO4217Currency(numericCode: "123", using: registry) == nil)
        #expect(ISO4217Currency(numericCode: "456", using: registry) == currency2)
        #expect(ISO4217Currency(alphabeticCode: "ABC", using: registry) == currency2)
        #expect(registry.currencies == [currency2])
    }

    // MARK: - Predefined Currencies Tests

    @Test
    func currency_whenInitializedWithPredefinedCurrencyRegistry_createsCurrency() {
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
