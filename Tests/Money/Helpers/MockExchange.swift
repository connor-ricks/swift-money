import Foundation
import Money

// MARK: - MockExchange

struct MockExchange: Exchange {

    // MARK: Properties

    let provider: (_ base: any Currency, _ quote: any Currency) throws -> Decimal

    // MARK: Exchange

    func rate<Base: Currency, Quote: Currency>(base: Base, quote: Quote) throws -> Decimal {
        try provider(base, quote)
    }
}

// MARK: - AsyncMockExchange

struct AsyncMockExchange: AsyncExchange {

    // MARK: Properties

    let provider: (_ base: any Currency, _ quote: any Currency) async throws -> Decimal

    // MARK: Exchange

    func rate<Base: Currency, Quote: Currency>(base: Base, quote: Quote) async throws -> Decimal {
        try await provider(base, quote)
    }
}

