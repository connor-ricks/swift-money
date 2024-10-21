import Foundation

extension Decimal {
    /// A rounded version of the decimal using the provided ``Currency`` .
    @inlinable func rounded<C: Currency>(for currency: C) -> Decimal {
        var approximate = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &approximate, currency.minorUnits, .bankers)
        return rounded
    }

    /// Rounds the decimal value using the provided ``Currency``.
    @inlinable mutating func rounding<C: Currency>(for currency: C) {
        self = rounded(for: currency)
    }
}
