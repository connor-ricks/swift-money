import Foundation
import Money

// MARK: - MockCurrency

struct MockCurrency: Currency {
    
    // MARK: Properties
    
    var id: String
    var minorUnits: Int
    
    // MARK: Iniitalizers
    
    init(id: String = "mock", minorUnits: Int = 2) {
        self.id = id
        self.minorUnits = minorUnits
    }
}

// MARK: - Currency + MockCurrency

extension Currency where Self == MockCurrency {
    static var foo: MockCurrency {
        MockCurrency(id: "foo", minorUnits: 0)
    }

    static var bar: MockCurrency {
        MockCurrency(id: "bar", minorUnits: 1)
    }

    static var biz: MockCurrency {
        MockCurrency(id: "biz", minorUnits: 2)
    }

    static var baz: MockCurrency {
        MockCurrency(id: "baz", minorUnits: 3)
    }
}
