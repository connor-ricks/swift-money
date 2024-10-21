import Foundation

// MARK: - Currency

/// Currency is a medium of exchange for goods and services, typically issued by a government and
/// circulated within an economy. It serves as a unit of account, a store of value, and a medium of exchange.
///
/// A ``Currency`` requires providing an identifying ``id`` used to uniquely identiy it among other
/// currencies, as well as a ``minorUnits`` value representing the number of minor units the currency
/// supports. (i.e USD supports 2 minor units)
public protocol Currency<ID>: Identifiable, Hashable {
    /// A unique identifier for the currency.
    var id: ID { get }
    /// The number of decimal places used to express any minor units for the currency.
    var minorUnits: Int { get }
}

// MARK: - Currency + Equatability

extension Currency {
    /// Returns a boolean that expresses whether or not two currencies are the equal.
    @inlinable public func isEqual<C: Currency>(to currency: C) -> Bool {
        func isEqual<LHS: Currency, RHS: Currency>(_ lhs: LHS, _ rhs: RHS) -> Bool {
            (lhs as? RHS).map { $0 == rhs } ?? false
        }

        return isEqual(currency, self)
    }
}
