public import Foundation

extension Decimal {
    /// A rounded version of the decimal using the provided ``Currency`` .
    ///
    /// - Important: If no scale is provided, the currency's minor units are used.
    @inlinable
    func rounded(
        for currency: some Currency,
        scale: Int? = nil,
        mode: NSDecimalNumber.RoundingMode = .bankers
    ) -> Decimal {
        var approximate = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &approximate, scale ?? currency.minorUnits, mode)
        return rounded
    }

    /// Rounds the decimal value using the provided ``Currency``.
    ///
    /// - Important: If no scale is provided, the currency's minor units are used.
    @inlinable
    mutating func rounding(
        for currency: some Currency,
        scale: Int? = nil,
        mode: NSDecimalNumber.RoundingMode = .bankers
    ) {
        self = rounded(
            for: currency,
            scale: scale,
            mode: mode
        )
    }
}
