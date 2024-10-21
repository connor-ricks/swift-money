@testable import Money
import XCTest

final class MoneyTests: XCTestCase {

    // MARK: Initialization Tests

    func test_money_whenInitializedMatchesParameters() {
        let foo = Money(amount: 2.5, currency: .foo)
        XCTAssertEqual(foo.amount, 2.5)
        XCTAssertTrue(foo.currency.isEqual(to: .foo))
        XCTAssertEqual(foo.currency.minorUnits, MockCurrency.foo.minorUnits)

        let bar = Money(minorUnits: 50, currency: .biz)
        XCTAssertEqual(bar.amount, 0.5)
        XCTAssertTrue(bar.currency.isEqual(to: .biz))
        XCTAssertEqual(bar.currency.minorUnits, MockCurrency.biz.minorUnits)

        let baz = Money(amount: -2.5, currency: .foo)
        XCTAssertEqual(baz.amount, -2.5)
        XCTAssertTrue(baz.currency.isEqual(to: .foo))
        XCTAssertEqual(baz.currency.minorUnits, MockCurrency.foo.minorUnits)

        let biz = Money(minorUnits: -50, currency: .biz)
        XCTAssertEqual(biz.amount, -0.5)
        XCTAssertTrue(biz.currency.isEqual(to: .biz))
        XCTAssertEqual(biz.currency.minorUnits, MockCurrency.biz.minorUnits)

        print(foo)
    }

    // MARK: Equatable Tests

    func test_money_withMatchingAmountsAndSameCurrency_areEqual() {
        XCTAssertEqual(
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .foo)
        )
    }

    func test_money_withMatchingAmountsAndDifferentCurrencies_areNotEqual() {
        XCTAssertNotEqual(
            Money(amount: 1, currency: .foo),
            Money(amount: 1, currency: .bar)
        )
    }

    func test_money_withDifferentAmounts_areNotEqual() {
        XCTAssertNotEqual(
            Money(amount: 1, currency: .foo),
            Money(amount: 1.1, currency: .foo)
        )
    }

    // MARK: Rounding Tests

    func test_money_whenRounded_roundsToCurrencyMinorUnits() {
        let foo = Money(amount: 2.5, currency: .foo)
        XCTAssertEqual(foo.rounded().amount, 2)

        var bar = Money(amount: 2.5, currency: .foo)
        bar.round()
        XCTAssertEqual(bar.amount, 2)

        let biz = Money(amount: 2.3333333, currency: .baz)
        XCTAssertEqual(biz.rounded().amount, 2.333)

        var baz = Money(amount: 2.3333333, currency: .baz)
        baz.round()
        XCTAssertEqual(baz.amount, 2.333)
    }

    // MARK: Converting Tests

    func test_money_whenConverted_matchesRateAndCurrency() {
        let biz = Money(amount: 10, currency: .foo)
        let convertedBiz = biz.converted(to: .bar, rate: 0.5)
        XCTAssertEqual(convertedBiz, Money(amount: 20, currency: .bar))

        var baz = Money(amount: 10, currency: .foo)
        baz.convert(to: .bar, rate: 0.5)
        XCTAssertEqual(baz, Money(amount: 20, currency: .bar))
    }

    // MARK: Arithmetic Tests

    func test_money_whenAddedWithDecimal_updatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        XCTAssertEqual(
            foo + Decimal(5),
            Money(amount: 6, currency: .foo)
        )

        XCTAssertEqual(
            foo + Decimal(-1),
            Money(amount: 0, currency: .foo)
        )

        XCTAssertEqual(
            Decimal(3) + foo,
            Money(amount: 4, currency: .foo)
        )

        XCTAssertEqual(
            Decimal(-2) + foo,
            Money(amount: -1, currency: .foo)
        )

        var bar = Money(amount: 0, currency: .bar)
        bar += Decimal(1)
        XCTAssertEqual(bar, Money(amount: 1, currency: .bar))

        bar += Decimal(-5)
        XCTAssertEqual(bar, Money(amount: -4, currency: .bar))
    }

    func test_money_whenAddedWithInt_increasesupdatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        XCTAssertEqual(
            foo + 5,
            Money(amount: 6, currency: .foo)
        )

        XCTAssertEqual(
            foo + -1,
            Money(amount: 0, currency: .foo)
        )

        XCTAssertEqual(
            3 + foo,
            Money(amount: 4, currency: .foo)
        )

        XCTAssertEqual(
            -2 + foo,
            Money(amount: -1, currency: .foo)
        )

        var bar = Money(amount: 0, currency: .bar)
        bar += 1
        XCTAssertEqual(bar, Money(amount: 1, currency: .bar))

        bar += -5
        XCTAssertEqual(bar, Money(amount: -4, currency: .bar))
    }

    func test_money_whenSubtractedWithDecimal_updatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        XCTAssertEqual(
            foo - Decimal(5),
            Money(amount: -4, currency: .foo)
        )

        XCTAssertEqual(
            foo - Decimal(-1),
            Money(amount: 2, currency: .foo)
        )

        XCTAssertEqual(
            Decimal(3) - foo,
            Money(amount: 2, currency: .foo)
        )

        XCTAssertEqual(
            Decimal(-2) - foo,
            Money(amount: -3, currency: .foo)
        )

        var bar = Money(amount: 0, currency: .bar)
        bar -= Decimal(1)
        XCTAssertEqual(bar, Money(amount: -1, currency: .bar))

        bar -= Decimal(-5)
        XCTAssertEqual(bar, Money(amount: 4, currency: .bar))
    }

    func test_money_whenSubtractedWithInt_updatesMonetaryAmount() {
        let foo = Money(amount: 1, currency: .foo)

        XCTAssertEqual(
            foo - 5,
            Money(amount: -4, currency: .foo)
        )

        XCTAssertEqual(
            foo - -1,
            Money(amount: 2, currency: .foo)
        )

        XCTAssertEqual(
            3 - foo,
            Money(amount: 2, currency: .foo)
        )

        XCTAssertEqual(
            -2 - foo,
            Money(amount: -3, currency: .foo)
        )

        var bar = Money(amount: 0, currency: .bar)
        bar -= 1
        XCTAssertEqual(bar, Money(amount: -1, currency: .bar))

        bar -= -5
        XCTAssertEqual(bar, Money(amount: 4, currency: .bar))
    }

    func test_money_whenAddedWithMoneyThatHasSameCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .foo)
        let biz = foo + bar

        XCTAssertEqual(biz, AggregatedMoney(amounts: [
            .init(.foo): 2.5
        ]))
    }

    func test_money_whenAddedWithMoneyThatHasDifferentCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .bar)
        let biz = foo + bar

        XCTAssertEqual(biz[.foo], 1)
        XCTAssertEqual(biz[.bar], 1.5)
        XCTAssertEqual(biz.currencies.count, 2)
    }

    func test_money_whenSubractedWithMoneyThatHasSameCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .foo)
        let biz = foo - bar

        XCTAssertEqual(biz[.foo], -0.5)
        XCTAssertEqual(biz.currencies.count, 1)
    }

    func test_money_whenSubtractedWithMoneyThatHasDifferentCurrency_createsAggregatedCurrency() {
        let foo = Money(amount: 1, currency: .foo)
        let bar = Money(amount: 1.5, currency: .bar)
        let biz = foo - bar

        XCTAssertEqual(biz[.foo], 1)
        XCTAssertEqual(biz[.bar], -1.5)
        XCTAssertEqual(biz.currencies.count, 2)
    }

    func test_money_whenMultipliedByAScalarValue_multipliesAmountCorrectly() {
        var money = Money(amount: 2, currency: .foo)

        // Decimal
        money = money * Decimal(-3)
        XCTAssertEqual(money, Money(amount: -6, currency: .foo))

        money = Decimal(2) * money
        XCTAssertEqual(money, Money(amount: -12, currency: .foo))

        money *= Decimal(-5)
        XCTAssertEqual(money, Money(amount: 60, currency: .foo))

        // Int
        money = money * Int(-2)
        XCTAssertEqual(money, Money(amount: -120, currency: .foo))

        money = Int(-3) * money
        XCTAssertEqual(money, Money(amount: 360, currency: .foo))

        money *= Int(2)
        XCTAssertEqual(money, Money(amount: 720, currency: .foo))
    }

    func test_money_whenDividedByAScalarValue_dividesAmountCorrectly() {
        var money = Money(amount: 720, currency: .foo)

        // Decimal
        money = money / Decimal(2)
        XCTAssertEqual(money, Money(amount: 360, currency: .foo))

        money = Decimal(-43_200) / money
        XCTAssertEqual(money, Money(amount: -120, currency: .foo))

        money /= Decimal(-2)
        XCTAssertEqual(money, Money(amount: 60, currency: .foo))

        // Int
        money = money / Int(-5)
        XCTAssertEqual(money, Money(amount: -12, currency: .foo))

        money = Int(72) / money
        XCTAssertEqual(money, Money(amount: -6, currency: .foo))

        money /= Int(-3)
        XCTAssertEqual(money, Money(amount: 2, currency: .foo))
    }

    func test_money_whenNegated_doesNegateAmount() {
        var money = Money(amount: 10, currency: .foo)

        money = -money
        XCTAssertEqual(money, Money(amount: -10, currency: .foo))

        money = -money
        XCTAssertEqual(money, Money(amount: 10, currency: .foo))
    }
}
