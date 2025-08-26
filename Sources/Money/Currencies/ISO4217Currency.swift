import Foundation

// MARK: - ISO4217Currency

/// An ISO 4217 currency represented by internationally recognized codes for the representation
/// of currencies that enable clarity and reduce errors. Currencies are represented using three letters.
/// Some of the alphabetic codes for major currencies are familiar, such as “EUR” for Euros.
public struct ISO4217Currency: Currency {

    // MARK: Properties

    /// A unique identifier for the currency.
    @inlinable public var id: String { "\(alphabeticCode)" }

    /// The three letter ISO 4217 currency code.
    public var alphabeticCode: String

    /// The three digit ISO 4217 currency code.
    public var numericCode: String

    /// The name of the currency.
    public var name: String

    /// The number of decimal places used to express any minor units for the currency.
    public var minorUnits: Int

    // MARK: Initializers

    /// Creates an ISO 4217 Country code from the provided codes, minor units and name.
    public init(
        alphabeticCode: String,
        numericCode: String,
        minorUnits: Int,
        name: String
    ) {
        precondition(alphabeticCode.count == 3)
        precondition(numericCode.count == 3)
        self.alphabeticCode = alphabeticCode
        self.numericCode = numericCode
        self.minorUnits = minorUnits
        self.name = name
    }
}

// MARK: - Currency + ISO 4217 Currencies

extension Currency where Self == ISO4217Currency {
    /// UAE Dirham (AED) or (784)
    @inlinable public static var AED: ISO4217Currency { .init(alphabeticCode: "AED", numericCode: "784", minorUnits: 2, name: "UAE Dirham") }

    /// Afghani (AFN) or (971)
    @inlinable public static var AFN: ISO4217Currency { .init(alphabeticCode: "AFN", numericCode: "971", minorUnits: 2, name: "Afghani") }

    /// Lek (ALL) or (008)
    @inlinable public static var ALL: ISO4217Currency { .init(alphabeticCode: "ALL", numericCode: "008", minorUnits: 2, name: "Lek") }

    /// Armenian Dram (AMD) or (051)
    @inlinable public static var AMD: ISO4217Currency { .init(alphabeticCode: "AMD", numericCode: "051", minorUnits: 2, name: "Armenian Dram") }

    /// Kwanza (AOA) or (973)
    @inlinable public static var AOA: ISO4217Currency { .init(alphabeticCode: "AOA", numericCode: "973", minorUnits: 2, name: "Kwanza") }

    /// Argentine Peso (ARS) or (032)
    @inlinable public static var ARS: ISO4217Currency { .init(alphabeticCode: "ARS", numericCode: "032", minorUnits: 2, name: "Argentine Peso") }

    /// Australian Dollar (AUD) or (036)
    @inlinable public static var AUD: ISO4217Currency { .init(alphabeticCode: "AUD", numericCode: "036", minorUnits: 2, name: "Australian Dollar") }

    /// Aruban Florin (AWG) or (533)
    @inlinable public static var AWG: ISO4217Currency { .init(alphabeticCode: "AWG", numericCode: "533", minorUnits: 2, name: "Aruban Florin") }

    /// Azerbaijan Manat (AZN) or (944)
    @inlinable public static var AZN: ISO4217Currency { .init(alphabeticCode: "AZN", numericCode: "944", minorUnits: 2, name: "Azerbaijan Manat") }

    /// Convertible Mark (BAM) or (977)
    @inlinable public static var BAM: ISO4217Currency { .init(alphabeticCode: "BAM", numericCode: "977", minorUnits: 2, name: "Convertible Mark") }

    /// Barbados Dollar (BBD) or (052)
    @inlinable public static var BBD: ISO4217Currency { .init(alphabeticCode: "BBD", numericCode: "052", minorUnits: 2, name: "Barbados Dollar") }

    /// Taka (BDT) or (050)
    @inlinable public static var BDT: ISO4217Currency { .init(alphabeticCode: "BDT", numericCode: "050", minorUnits: 2, name: "Taka") }

    /// Bulgarian Lev (BGN) or (975)
    @inlinable public static var BGN: ISO4217Currency { .init(alphabeticCode: "BGN", numericCode: "975", minorUnits: 2, name: "Bulgarian Lev") }

    /// Bahraini Dinar (BHD) or (048)
    @inlinable public static var BHD: ISO4217Currency { .init(alphabeticCode: "BHD", numericCode: "048", minorUnits: 3, name: "Bahraini Dinar") }

    /// Burundi Franc (BIF) or (108)
    @inlinable public static var BIF: ISO4217Currency { .init(alphabeticCode: "BIF", numericCode: "108", minorUnits: 0, name: "Burundi Franc") }

    /// Bermudian Dollar (BMD) or (060)
    @inlinable public static var BMD: ISO4217Currency { .init(alphabeticCode: "BMD", numericCode: "060", minorUnits: 2, name: "Bermudian Dollar") }

    /// Brunei Dollar (BND) or (096)
    @inlinable public static var BND: ISO4217Currency { .init(alphabeticCode: "BND", numericCode: "096", minorUnits: 2, name: "Brunei Dollar") }

    /// Boliviano (BOB) or (068)
    @inlinable public static var BOB: ISO4217Currency { .init(alphabeticCode: "BOB", numericCode: "068", minorUnits: 2, name: "Boliviano") }

    /// Brazilian Real (BRL) or (986)
    @inlinable public static var BRL: ISO4217Currency { .init(alphabeticCode: "BRL", numericCode: "986", minorUnits: 2, name: "Brazilian Real") }

    /// Bahamian Dollar (BSD) or (044)
    @inlinable public static var BSD: ISO4217Currency { .init(alphabeticCode: "BSD", numericCode: "044", minorUnits: 2, name: "Bahamian Dollar") }

    /// Ngultrum (BTN) or (064)
    @inlinable public static var BTN: ISO4217Currency { .init(alphabeticCode: "BTN", numericCode: "064", minorUnits: 2, name: "Ngultrum") }

    /// Pula (BWP) or (072)
    @inlinable public static var BWP: ISO4217Currency { .init(alphabeticCode: "BWP", numericCode: "072", minorUnits: 2, name: "Pula") }

    /// Belarusian Ruble (BYN) or (933)
    @inlinable public static var BYN: ISO4217Currency { .init(alphabeticCode: "BYN", numericCode: "933", minorUnits: 2, name: "Belarusian Ruble") }

    /// Belize Dollar (BZD) or (084)
    @inlinable public static var BZD: ISO4217Currency { .init(alphabeticCode: "BZD", numericCode: "084", minorUnits: 2, name: "Belize Dollar") }

    /// Canadian Dollar (CAD) or (124)
    @inlinable public static var CAD: ISO4217Currency { .init(alphabeticCode: "CAD", numericCode: "124", minorUnits: 2, name: "Canadian Dollar") }

    /// Congolese Franc (CDF) or (976)
    @inlinable public static var CDF: ISO4217Currency { .init(alphabeticCode: "CDF", numericCode: "976", minorUnits: 2, name: "Congolese Franc") }

    /// Swiss Franc (CHF) or (756)
    @inlinable public static var CHF: ISO4217Currency { .init(alphabeticCode: "CHF", numericCode: "756", minorUnits: 2, name: "Swiss Franc") }

    /// Chilean Peso (CLP) or (152)
    @inlinable public static var CLP: ISO4217Currency { .init(alphabeticCode: "CLP", numericCode: "152", minorUnits: 0, name: "Chilean Peso") }

    /// Yuan Renminbi (CNY) or (156)
    @inlinable public static var CNY: ISO4217Currency { .init(alphabeticCode: "CNY", numericCode: "156", minorUnits: 2, name: "Yuan Renminbi") }

    /// Colombian Peso (COP) or (170)
    @inlinable public static var COP: ISO4217Currency { .init(alphabeticCode: "COP", numericCode: "170", minorUnits: 2, name: "Colombian Peso") }

    /// Costa Rican Colon (CRC) or (188)
    @inlinable public static var CRC: ISO4217Currency { .init(alphabeticCode: "CRC", numericCode: "188", minorUnits: 2, name: "Costa Rican Colon") }

    /// Cuban Peso (CUP) or (192)
    @inlinable public static var CUP: ISO4217Currency { .init(alphabeticCode: "CUP", numericCode: "192", minorUnits: 2, name: "Cuban Peso") }

    /// Cabo Verde Escudo (CVE) or (132)
    @inlinable public static var CVE: ISO4217Currency { .init(alphabeticCode: "CVE", numericCode: "132", minorUnits: 2, name: "Cabo Verde Escudo") }

    /// Czech Koruna (CZK) or (203)
    @inlinable public static var CZK: ISO4217Currency { .init(alphabeticCode: "CZK", numericCode: "203", minorUnits: 2, name: "Czech Koruna") }

    /// Djibouti Franc (DJF) or (262)
    @inlinable public static var DJF: ISO4217Currency { .init(alphabeticCode: "DJF", numericCode: "262", minorUnits: 0, name: "Djibouti Franc") }

    /// Danish Krone (DKK) or (208)
    @inlinable public static var DKK: ISO4217Currency { .init(alphabeticCode: "DKK", numericCode: "208", minorUnits: 2, name: "Danish Krone") }

    /// Dominican Peso (DOP) or (214)
    @inlinable public static var DOP: ISO4217Currency { .init(alphabeticCode: "DOP", numericCode: "214", minorUnits: 2, name: "Dominican Peso") }

    /// Algerian Dinar (DZD) or (012)
    @inlinable public static var DZD: ISO4217Currency { .init(alphabeticCode: "DZD", numericCode: "012", minorUnits: 2, name: "Algerian Dinar") }

    /// Egyptian Pound (EGP) or (818)
    @inlinable public static var EGP: ISO4217Currency { .init(alphabeticCode: "EGP", numericCode: "818", minorUnits: 2, name: "Egyptian Pound") }

    /// Nakfa (ERN) or (232)
    @inlinable public static var ERN: ISO4217Currency { .init(alphabeticCode: "ERN", numericCode: "232", minorUnits: 2, name: "Nakfa") }

    /// Ethiopian Birr (ETB) or (230)
    @inlinable public static var ETB: ISO4217Currency { .init(alphabeticCode: "ETB", numericCode: "230", minorUnits: 2, name: "Ethiopian Birr") }

    /// Euro (EUR) or (978)
    @inlinable public static var EUR: ISO4217Currency { .init(alphabeticCode: "EUR", numericCode: "978", minorUnits: 2, name: "Euro") }

    /// Fiji Dollar (FJD) or (242)
    @inlinable public static var FJD: ISO4217Currency { .init(alphabeticCode: "FJD", numericCode: "242", minorUnits: 2, name: "Fiji Dollar") }

    /// Falkland Islands Pound (FKP) or (238)
    @inlinable public static var FKP: ISO4217Currency { .init(alphabeticCode: "FKP", numericCode: "238", minorUnits: 2, name: "Falkland Islands Pound") }

    /// Pound Sterling (GBP) or (826)
    @inlinable public static var GBP: ISO4217Currency { .init(alphabeticCode: "GBP", numericCode: "826", minorUnits: 2, name: "Pound Sterling") }

    /// Lari (GEL) or (981)
    @inlinable public static var GEL: ISO4217Currency { .init(alphabeticCode: "GEL", numericCode: "981", minorUnits: 2, name: "Lari") }

    /// Ghana Cedi (GHS) or (936)
    @inlinable public static var GHS: ISO4217Currency { .init(alphabeticCode: "GHS", numericCode: "936", minorUnits: 2, name: "Ghana Cedi") }

    /// Gibraltar Pound (GIP) or (292)
    @inlinable public static var GIP: ISO4217Currency { .init(alphabeticCode: "GIP", numericCode: "292", minorUnits: 2, name: "Gibraltar Pound") }

    /// Dalasi (GMD) or (270)
    @inlinable public static var GMD: ISO4217Currency { .init(alphabeticCode: "GMD", numericCode: "270", minorUnits: 2, name: "Dalasi") }

    /// Guinean Franc (GNF) or (324)
    @inlinable public static var GNF: ISO4217Currency { .init(alphabeticCode: "GNF", numericCode: "324", minorUnits: 0, name: "Guinean Franc") }

    /// Quetzal (GTQ) or (320)
    @inlinable public static var GTQ: ISO4217Currency { .init(alphabeticCode: "GTQ", numericCode: "320", minorUnits: 2, name: "Quetzal") }

    /// Guyana Dollar (GYD) or (328)
    @inlinable public static var GYD: ISO4217Currency { .init(alphabeticCode: "GYD", numericCode: "328", minorUnits: 2, name: "Guyana Dollar") }

    /// Hong Kong Dollar (HKD) or (344)
    @inlinable public static var HKD: ISO4217Currency { .init(alphabeticCode: "HKD", numericCode: "344", minorUnits: 2, name: "Hong Kong Dollar") }

    /// Lempira (HNL) or (340)
    @inlinable public static var HNL: ISO4217Currency { .init(alphabeticCode: "HNL", numericCode: "340", minorUnits: 2, name: "Lempira") }

    /// Gourde (HTG) or (332)
    @inlinable public static var HTG: ISO4217Currency { .init(alphabeticCode: "HTG", numericCode: "332", minorUnits: 2, name: "Gourde") }

    /// Forint (HUF) or (348)
    @inlinable public static var HUF: ISO4217Currency { .init(alphabeticCode: "HUF", numericCode: "348", minorUnits: 2, name: "Forint") }

    /// Rupiah (IDR) or (360)
    @inlinable public static var IDR: ISO4217Currency { .init(alphabeticCode: "IDR", numericCode: "360", minorUnits: 2, name: "Rupiah") }

    /// New Israeli Sheqel (ILS) or (376)
    @inlinable public static var ILS: ISO4217Currency { .init(alphabeticCode: "ILS", numericCode: "376", minorUnits: 2, name: "New Israeli Sheqel") }

    /// Indian Rupee (INR) or (356)
    @inlinable public static var INR: ISO4217Currency { .init(alphabeticCode: "INR", numericCode: "356", minorUnits: 2, name: "Indian Rupee") }

    /// Iraqi Dinar (IQD) or (368)
    @inlinable public static var IQD: ISO4217Currency { .init(alphabeticCode: "IQD", numericCode: "368", minorUnits: 3, name: "Iraqi Dinar") }

    /// Iranian Rial (IRR) or (364)
    @inlinable public static var IRR: ISO4217Currency { .init(alphabeticCode: "IRR", numericCode: "364", minorUnits: 2, name: "Iranian Rial") }

    /// Iceland Krona (ISK) or (352)
    @inlinable public static var ISK: ISO4217Currency { .init(alphabeticCode: "ISK", numericCode: "352", minorUnits: 0, name: "Iceland Krona") }

    /// Jamaican Dollar (JMD) or (388)
    @inlinable public static var JMD: ISO4217Currency { .init(alphabeticCode: "JMD", numericCode: "388", minorUnits: 2, name: "Jamaican Dollar") }

    /// Jordanian Dinar (JOD) or (400)
    @inlinable public static var JOD: ISO4217Currency { .init(alphabeticCode: "JOD", numericCode: "400", minorUnits: 3, name: "Jordanian Dinar") }

    /// Yen (JPY) or (392)
    @inlinable public static var JPY: ISO4217Currency { .init(alphabeticCode: "JPY", numericCode: "392", minorUnits: 0, name: "Yen") }

    /// Kenyan Shilling (KES) or (404)
    @inlinable public static var KES: ISO4217Currency { .init(alphabeticCode: "KES", numericCode: "404", minorUnits: 2, name: "Kenyan Shilling") }

    /// Som (KGS) or (417)
    @inlinable public static var KGS: ISO4217Currency { .init(alphabeticCode: "KGS", numericCode: "417", minorUnits: 2, name: "Som") }

    /// Riel (KHR) or (116)
    @inlinable public static var KHR: ISO4217Currency { .init(alphabeticCode: "KHR", numericCode: "116", minorUnits: 2, name: "Riel") }

    /// Comorian Franc (KMF) or (174)
    @inlinable public static var KMF: ISO4217Currency { .init(alphabeticCode: "KMF", numericCode: "174", minorUnits: 0, name: "Comorian Franc") }

    /// North Korean Won (KPW) or (408)
    @inlinable public static var KPW: ISO4217Currency { .init(alphabeticCode: "KPW", numericCode: "408", minorUnits: 2, name: "North Korean Won") }

    /// Won (KRW) or (410)
    @inlinable public static var KRW: ISO4217Currency { .init(alphabeticCode: "KRW", numericCode: "410", minorUnits: 0, name: "Won") }

    /// Kuwaiti Dinar (KWD) or (414)
    @inlinable public static var KWD: ISO4217Currency { .init(alphabeticCode: "KWD", numericCode: "414", minorUnits: 3, name: "Kuwaiti Dinar") }

    /// Cayman Islands Dollar (KYD) or (136)
    @inlinable public static var KYD: ISO4217Currency { .init(alphabeticCode: "KYD", numericCode: "136", minorUnits: 2, name: "Cayman Islands Dollar") }

    /// Tenge (KZT) or (398)
    @inlinable public static var KZT: ISO4217Currency { .init(alphabeticCode: "KZT", numericCode: "398", minorUnits: 2, name: "Tenge") }

    /// Lao Kip (LAK) or (418)
    @inlinable public static var LAK: ISO4217Currency { .init(alphabeticCode: "LAK", numericCode: "418", minorUnits: 2, name: "Lao Kip") }

    /// Lebanese Pound (LBP) or (422)
    @inlinable public static var LBP: ISO4217Currency { .init(alphabeticCode: "LBP", numericCode: "422", minorUnits: 2, name: "Lebanese Pound") }

    /// Sri Lanka Rupee (LKR) or (144)
    @inlinable public static var LKR: ISO4217Currency { .init(alphabeticCode: "LKR", numericCode: "144", minorUnits: 2, name: "Sri Lanka Rupee") }

    /// Liberian Dollar (LRD) or (430)
    @inlinable public static var LRD: ISO4217Currency { .init(alphabeticCode: "LRD", numericCode: "430", minorUnits: 2, name: "Liberian Dollar") }

    /// Loti (LSL) or (426)
    @inlinable public static var LSL: ISO4217Currency { .init(alphabeticCode: "LSL", numericCode: "426", minorUnits: 2, name: "Loti") }

    /// Libyan Dinar (LYD) or (434)
    @inlinable public static var LYD: ISO4217Currency { .init(alphabeticCode: "LYD", numericCode: "434", minorUnits: 3, name: "Libyan Dinar") }

    /// Moroccan Dirham (MAD) or (504)
    @inlinable public static var MAD: ISO4217Currency { .init(alphabeticCode: "MAD", numericCode: "504", minorUnits: 2, name: "Moroccan Dirham") }

    /// Moldovan Leu (MDL) or (498)
    @inlinable public static var MDL: ISO4217Currency { .init(alphabeticCode: "MDL", numericCode: "498", minorUnits: 2, name: "Moldovan Leu") }

    /// Malagasy Ariary (MGA) or (969)
    @inlinable public static var MGA: ISO4217Currency { .init(alphabeticCode: "MGA", numericCode: "969", minorUnits: 2, name: "Malagasy Ariary") }

    /// Denar (MKD) or (807)
    @inlinable public static var MKD: ISO4217Currency { .init(alphabeticCode: "MKD", numericCode: "807", minorUnits: 2, name: "Denar") }

    /// Kyat (MMK) or (104)
    @inlinable public static var MMK: ISO4217Currency { .init(alphabeticCode: "MMK", numericCode: "104", minorUnits: 2, name: "Kyat") }

    /// Tugrik (MNT) or (496)
    @inlinable public static var MNT: ISO4217Currency { .init(alphabeticCode: "MNT", numericCode: "496", minorUnits: 2, name: "Tugrik") }

    /// Pataca (MOP) or (446)
    @inlinable public static var MOP: ISO4217Currency { .init(alphabeticCode: "MOP", numericCode: "446", minorUnits: 2, name: "Pataca") }

    /// Ouguiya (MRU) or (929)
    @inlinable public static var MRU: ISO4217Currency { .init(alphabeticCode: "MRU", numericCode: "929", minorUnits: 2, name: "Ouguiya") }

    /// Mauritius Rupee (MUR) or (480)
    @inlinable public static var MUR: ISO4217Currency { .init(alphabeticCode: "MUR", numericCode: "480", minorUnits: 2, name: "Mauritius Rupee") }

    /// Rufiyaa (MVR) or (462)
    @inlinable public static var MVR: ISO4217Currency { .init(alphabeticCode: "MVR", numericCode: "462", minorUnits: 2, name: "Rufiyaa") }

    /// Malawi Kwacha (MWK) or (454)
    @inlinable public static var MWK: ISO4217Currency { .init(alphabeticCode: "MWK", numericCode: "454", minorUnits: 2, name: "Malawi Kwacha") }

    /// Mexican Peso (MXN) or (484)
    @inlinable public static var MXN: ISO4217Currency { .init(alphabeticCode: "MXN", numericCode: "484", minorUnits: 2, name: "Mexican Peso") }

    /// Malaysian Ringgit (MYR) or (458)
    @inlinable public static var MYR: ISO4217Currency { .init(alphabeticCode: "MYR", numericCode: "458", minorUnits: 2, name: "Malaysian Ringgit") }

    /// Mozambique Metical (MZN) or (943)
    @inlinable public static var MZN: ISO4217Currency { .init(alphabeticCode: "MZN", numericCode: "943", minorUnits: 2, name: "Mozambique Metical") }

    /// Namibia Dollar (NAD) or (516)
    @inlinable public static var NAD: ISO4217Currency { .init(alphabeticCode: "NAD", numericCode: "516", minorUnits: 2, name: "Namibia Dollar") }

    /// Naira (NGN) or (566)
    @inlinable public static var NGN: ISO4217Currency { .init(alphabeticCode: "NGN", numericCode: "566", minorUnits: 2, name: "Naira") }

    /// Cordoba Oro (NIO) or (558)
    @inlinable public static var NIO: ISO4217Currency { .init(alphabeticCode: "NIO", numericCode: "558", minorUnits: 2, name: "Cordoba Oro") }

    /// Norwegian Krone (NOK) or (578)
    @inlinable public static var NOK: ISO4217Currency { .init(alphabeticCode: "NOK", numericCode: "578", minorUnits: 2, name: "Norwegian Krone") }

    /// Nepalese Rupee (NPR) or (524)
    @inlinable public static var NPR: ISO4217Currency { .init(alphabeticCode: "NPR", numericCode: "524", minorUnits: 2, name: "Nepalese Rupee") }

    /// New Zealand Dollar (NZD) or (554)
    @inlinable public static var NZD: ISO4217Currency { .init(alphabeticCode: "NZD", numericCode: "554", minorUnits: 2, name: "New Zealand Dollar") }

    /// Rial Omani (OMR) or (512)
    @inlinable public static var OMR: ISO4217Currency { .init(alphabeticCode: "OMR", numericCode: "512", minorUnits: 3, name: "Rial Omani") }

    /// Balboa (PAB) or (590)
    @inlinable public static var PAB: ISO4217Currency { .init(alphabeticCode: "PAB", numericCode: "590", minorUnits: 2, name: "Balboa") }

    /// Sol (PEN) or (604)
    @inlinable public static var PEN: ISO4217Currency { .init(alphabeticCode: "PEN", numericCode: "604", minorUnits: 2, name: "Sol") }

    /// Kina (PGK) or (598)
    @inlinable public static var PGK: ISO4217Currency { .init(alphabeticCode: "PGK", numericCode: "598", minorUnits: 2, name: "Kina") }

    /// Philippine Peso (PHP) or (608)
    @inlinable public static var PHP: ISO4217Currency { .init(alphabeticCode: "PHP", numericCode: "608", minorUnits: 2, name: "Philippine Peso") }

    /// Pakistan Rupee (PKR) or (586)
    @inlinable public static var PKR: ISO4217Currency { .init(alphabeticCode: "PKR", numericCode: "586", minorUnits: 2, name: "Pakistan Rupee") }

    /// Zloty (PLN) or (985)
    @inlinable public static var PLN: ISO4217Currency { .init(alphabeticCode: "PLN", numericCode: "985", minorUnits: 2, name: "Zloty") }

    /// Guarani (PYG) or (600)
    @inlinable public static var PYG: ISO4217Currency { .init(alphabeticCode: "PYG", numericCode: "600", minorUnits: 0, name: "Guarani") }

    /// Qatari Rial (QAR) or (634)
    @inlinable public static var QAR: ISO4217Currency { .init(alphabeticCode: "QAR", numericCode: "634", minorUnits: 2, name: "Qatari Rial") }

    /// Romanian Leu (RON) or (946)
    @inlinable public static var RON: ISO4217Currency { .init(alphabeticCode: "RON", numericCode: "946", minorUnits: 2, name: "Romanian Leu") }

    /// Serbian Dinar (RSD) or (941)
    @inlinable public static var RSD: ISO4217Currency { .init(alphabeticCode: "RSD", numericCode: "941", minorUnits: 2, name: "Serbian Dinar") }

    /// Russian Ruble (RUB) or (643)
    @inlinable public static var RUB: ISO4217Currency { .init(alphabeticCode: "RUB", numericCode: "643", minorUnits: 2, name: "Russian Ruble") }

    /// Rwanda Franc (RWF) or (646)
    @inlinable public static var RWF: ISO4217Currency { .init(alphabeticCode: "RWF", numericCode: "646", minorUnits: 0, name: "Rwanda Franc") }

    /// Saudi Riyal (SAR) or (682)
    @inlinable public static var SAR: ISO4217Currency { .init(alphabeticCode: "SAR", numericCode: "682", minorUnits: 2, name: "Saudi Riyal") }

    /// Solomon Islands Dollar (SBD) or (090)
    @inlinable public static var SBD: ISO4217Currency { .init(alphabeticCode: "SBD", numericCode: "090", minorUnits: 2, name: "Solomon Islands Dollar") }

    /// Seychelles Rupee (SCR) or (690)
    @inlinable public static var SCR: ISO4217Currency { .init(alphabeticCode: "SCR", numericCode: "690", minorUnits: 2, name: "Seychelles Rupee") }

    /// Sudanese Pound (SDG) or (938)
    @inlinable public static var SDG: ISO4217Currency { .init(alphabeticCode: "SDG", numericCode: "938", minorUnits: 2, name: "Sudanese Pound") }

    /// Swedish Krona (SEK) or (752)
    @inlinable public static var SEK: ISO4217Currency { .init(alphabeticCode: "SEK", numericCode: "752", minorUnits: 2, name: "Swedish Krona") }

    /// Singapore Dollar (SGD) or (702)
    @inlinable public static var SGD: ISO4217Currency { .init(alphabeticCode: "SGD", numericCode: "702", minorUnits: 2, name: "Singapore Dollar") }

    /// Saint Helena Pound (SHP) or (654)
    @inlinable public static var SHP: ISO4217Currency { .init(alphabeticCode: "SHP", numericCode: "654", minorUnits: 2, name: "Saint Helena Pound") }

    /// Leone (SLE) or (925)
    @inlinable public static var SLE: ISO4217Currency { .init(alphabeticCode: "SLE", numericCode: "925", minorUnits: 2, name: "Leone") }

    /// Somali Shilling (SOS) or (706)
    @inlinable public static var SOS: ISO4217Currency { .init(alphabeticCode: "SOS", numericCode: "706", minorUnits: 2, name: "Somali Shilling") }

    /// Surinam Dollar (SRD) or (968)
    @inlinable public static var SRD: ISO4217Currency { .init(alphabeticCode: "SRD", numericCode: "968", minorUnits: 2, name: "Surinam Dollar") }

    /// South Sudanese Pound (SSP) or (728)
    @inlinable public static var SSP: ISO4217Currency { .init(alphabeticCode: "SSP", numericCode: "728", minorUnits: 2, name: "South Sudanese Pound") }

    /// Dobra (STN) or (930)
    @inlinable public static var STN: ISO4217Currency { .init(alphabeticCode: "STN", numericCode: "930", minorUnits: 2, name: "Dobra") }

    /// El Salvador Colon (SVC) or (222)
    @inlinable public static var SVC: ISO4217Currency { .init(alphabeticCode: "SVC", numericCode: "222", minorUnits: 2, name: "El Salvador Colon") }

    /// Syrian Pound (SYP) or (760)
    @inlinable public static var SYP: ISO4217Currency { .init(alphabeticCode: "SYP", numericCode: "760", minorUnits: 2, name: "Syrian Pound") }

    /// Lilangeni (SZL) or (748)
    @inlinable public static var SZL: ISO4217Currency { .init(alphabeticCode: "SZL", numericCode: "748", minorUnits: 2, name: "Lilangeni") }

    /// Baht (THB) or (764)
    @inlinable public static var THB: ISO4217Currency { .init(alphabeticCode: "THB", numericCode: "764", minorUnits: 2, name: "Baht") }

    /// Somoni (TJS) or (972)
    @inlinable public static var TJS: ISO4217Currency { .init(alphabeticCode: "TJS", numericCode: "972", minorUnits: 2, name: "Somoni") }

    /// Turkmenistan New Manat (TMT) or (934)
    @inlinable public static var TMT: ISO4217Currency { .init(alphabeticCode: "TMT", numericCode: "934", minorUnits: 2, name: "Turkmenistan New Manat") }

    /// Tunisian Dinar (TND) or (788)
    @inlinable public static var TND: ISO4217Currency { .init(alphabeticCode: "TND", numericCode: "788", minorUnits: 3, name: "Tunisian Dinar") }

    /// Pa’anga (TOP) or (776)
    @inlinable public static var TOP: ISO4217Currency { .init(alphabeticCode: "TOP", numericCode: "776", minorUnits: 2, name: "Pa’anga") }

    /// Turkish Lira (TRY) or (949)
    @inlinable public static var TRY: ISO4217Currency { .init(alphabeticCode: "TRY", numericCode: "949", minorUnits: 2, name: "Turkish Lira") }

    /// Trinidad and Tobago Dollar (TTD) or (780)
    @inlinable public static var TTD: ISO4217Currency { .init(alphabeticCode: "TTD", numericCode: "780", minorUnits: 2, name: "Trinidad and Tobago Dollar") }

    /// New Taiwan Dollar (TWD) or (901)
    @inlinable public static var TWD: ISO4217Currency { .init(alphabeticCode: "TWD", numericCode: "901", minorUnits: 2, name: "New Taiwan Dollar") }

    /// Tanzanian Shilling (TZS) or (834)
    @inlinable public static var TZS: ISO4217Currency { .init(alphabeticCode: "TZS", numericCode: "834", minorUnits: 2, name: "Tanzanian Shilling") }

    /// Hryvnia (UAH) or (980)
    @inlinable public static var UAH: ISO4217Currency { .init(alphabeticCode: "UAH", numericCode: "980", minorUnits: 2, name: "Hryvnia") }

    /// Uganda Shilling (UGX) or (800)
    @inlinable public static var UGX: ISO4217Currency { .init(alphabeticCode: "UGX", numericCode: "800", minorUnits: 0, name: "Uganda Shilling") }

    /// US Dollar (USD) or (840)
    @inlinable public static var USD: ISO4217Currency { .init(alphabeticCode: "USD", numericCode: "840", minorUnits: 2, name: "US Dollar") }

    /// Peso Uruguayo (UYU) or (858)
    @inlinable public static var UYU: ISO4217Currency { .init(alphabeticCode: "UYU", numericCode: "858", minorUnits: 2, name: "Peso Uruguayo") }

    /// Uzbekistan Sum (UZS) or (860)
    @inlinable public static var UZS: ISO4217Currency { .init(alphabeticCode: "UZS", numericCode: "860", minorUnits: 2, name: "Uzbekistan Sum") }

    /// Bolívar Soberano (VED) or (926)
    @inlinable public static var VED: ISO4217Currency { .init(alphabeticCode: "VED", numericCode: "926", minorUnits: 2, name: "Bolívar Soberano") }

    /// Bolívar Soberano (VES) or (928)
    @inlinable public static var VES: ISO4217Currency { .init(alphabeticCode: "VES", numericCode: "928", minorUnits: 2, name: "Bolívar Soberano") }

    /// Dong (VND) or (704)
    @inlinable public static var VND: ISO4217Currency { .init(alphabeticCode: "VND", numericCode: "704", minorUnits: 0, name: "Dong") }

    /// Vatu (VUV) or (548)
    @inlinable public static var VUV: ISO4217Currency { .init(alphabeticCode: "VUV", numericCode: "548", minorUnits: 0, name: "Vatu") }

    /// Tala (WST) or (882)
    @inlinable public static var WST: ISO4217Currency { .init(alphabeticCode: "WST", numericCode: "882", minorUnits: 2, name: "Tala") }

    /// CFA Franc BEAC (XAF) or (950)
    @inlinable public static var XAF: ISO4217Currency { .init(alphabeticCode: "XAF", numericCode: "950", minorUnits: 0, name: "CFA Franc BEAC") }

    /// East Caribbean Dollar (XCD) or (951)
    @inlinable public static var XCD: ISO4217Currency { .init(alphabeticCode: "XCD", numericCode: "951", minorUnits: 2, name: "East Caribbean Dollar") }

    /// Caribbean Guilder (XCG) or (532)
    @inlinable public static var XCG: ISO4217Currency { .init(alphabeticCode: "XCG", numericCode: "532", minorUnits: 2, name: "Caribbean Guilder") }

    /// CFA Franc BCEAO (XOF) or (952)
    @inlinable public static var XOF: ISO4217Currency { .init(alphabeticCode: "XOF", numericCode: "952", minorUnits: 0, name: "CFA Franc BCEAO") }

    /// CFP Franc (XPF) or (953)
    @inlinable public static var XPF: ISO4217Currency { .init(alphabeticCode: "XPF", numericCode: "953", minorUnits: 0, name: "CFP Franc") }

    /// Yemeni Rial (YER) or (886)
    @inlinable public static var YER: ISO4217Currency { .init(alphabeticCode: "YER", numericCode: "886", minorUnits: 2, name: "Yemeni Rial") }

    /// Rand (ZAR) or (710)
    @inlinable public static var ZAR: ISO4217Currency { .init(alphabeticCode: "ZAR", numericCode: "710", minorUnits: 2, name: "Rand") }

    /// Zambian Kwacha (ZMW) or (967)
    @inlinable public static var ZMW: ISO4217Currency { .init(alphabeticCode: "ZMW", numericCode: "967", minorUnits: 2, name: "Zambian Kwacha") }

    /// Zimbabwe Gold (ZWG) or (924)
    @inlinable public static var ZWG: ISO4217Currency { .init(alphabeticCode: "ZWG", numericCode: "924", minorUnits: 2, name: "Zimbabwe Gold") }

    /// An array of all the ISO 4217 currencies defined in the package.
    /// - Important: Updated 2025-05-12 from [ISO 4217](https://www.iso.org/iso-4217-currency-codes.html)
    @inlinable public static var predefinedISO4217Currencies: [ISO4217Currency] {
        [
            .AED,
            .AFN,
            .ALL,
            .AMD,
            .AOA,
            .ARS,
            .AUD,
            .AWG,
            .AZN,
            .BAM,
            .BBD,
            .BDT,
            .BGN,
            .BHD,
            .BIF,
            .BMD,
            .BND,
            .BOB,
            .BRL,
            .BSD,
            .BTN,
            .BWP,
            .BYN,
            .BZD,
            .CAD,
            .CDF,
            .CHF,
            .CLP,
            .CNY,
            .COP,
            .CRC,
            .CUP,
            .CVE,
            .CZK,
            .DJF,
            .DKK,
            .DOP,
            .DZD,
            .EGP,
            .ERN,
            .ETB,
            .EUR,
            .FJD,
            .FKP,
            .GBP,
            .GEL,
            .GHS,
            .GIP,
            .GMD,
            .GNF,
            .GTQ,
            .GYD,
            .HKD,
            .HNL,
            .HTG,
            .HUF,
            .IDR,
            .ILS,
            .INR,
            .IQD,
            .IRR,
            .ISK,
            .JMD,
            .JOD,
            .JPY,
            .KES,
            .KGS,
            .KHR,
            .KMF,
            .KPW,
            .KRW,
            .KWD,
            .KYD,
            .KZT,
            .LAK,
            .LBP,
            .LKR,
            .LRD,
            .LSL,
            .LYD,
            .MAD,
            .MDL,
            .MGA,
            .MKD,
            .MMK,
            .MNT,
            .MOP,
            .MRU,
            .MUR,
            .MVR,
            .MWK,
            .MXN,
            .MYR,
            .MZN,
            .NAD,
            .NGN,
            .NIO,
            .NOK,
            .NPR,
            .NZD,
            .OMR,
            .PAB,
            .PEN,
            .PGK,
            .PHP,
            .PKR,
            .PLN,
            .PYG,
            .QAR,
            .RON,
            .RSD,
            .RUB,
            .RWF,
            .SAR,
            .SBD,
            .SCR,
            .SDG,
            .SEK,
            .SGD,
            .SHP,
            .SLE,
            .SOS,
            .SRD,
            .SSP,
            .STN,
            .SVC,
            .SYP,
            .SZL,
            .THB,
            .TJS,
            .TMT,
            .TND,
            .TOP,
            .TRY,
            .TTD,
            .TWD,
            .TZS,
            .UAH,
            .UGX,
            .USD,
            .UYU,
            .UZS,
            .VED,
            .VES,
            .VND,
            .VUV,
            .WST,
            .XAF,
            .XCD,
            .XCG,
            .XOF,
            .XPF,
            .YER,
            .ZAR,
            .ZMW,
            .ZWG,
        ]
    }
}

// MARK: - ISO4217CurrencyRegistry

/// A thread-safe registry for custom ISO4217 currencies.
public final class ISO4217CurrencyRegistry: Sendable {

    // MARK: Key

    /// A key for currency lookups that can be either alphabetic or numeric code.
    private enum Key: Hashable {
        case alphabetic(String)
        case numeric(String)
    }

    // MARK: Value

    /// A reference wrapper for storing currencies to avoid duplication.
    private final class Value {
        let currency: ISO4217Currency
        init(_ currency: ISO4217Currency) {
            self.currency = currency
        }
    }

    // MARK: Properties

    /// A lock that allows thread-safe access to the registry.
    private let registryLock = NSRecursiveLock()

    /// A unified lookup table for currencies by their codes.
    private nonisolated(unsafe) var registry: [Key: Value] = [:]

    /// Returns all currencies currently registered with the registry.
    public var currencies: Set<ISO4217Currency> {
        registryLock.lock()
        defer { registryLock.unlock() }
        return Set(registry.values.map(\.currency))
    }

    // MARK: Helpers

    /// Registers the provided currency with the system.
    ///
    /// Doing so allows initialization of an ``ISO4217Currency`` using its numeric or alphabetic code.
    ///
    /// - Important: Registering a currency that already exists will overwrite the previously registered currency.
    ///
    /// - Warning: Registering a currency with the a partial code match will result in the removal of the previous currency.
    ///            i.e Adding `USD/123` and then adding `USD/512` will result in `USD/512` replacing the currency entirely.
    ///            No orpahned currencies will be permitted.
    public func register(_ currency: ISO4217Currency) {
        registryLock.lock()
        defer { registryLock.unlock() }

        // Check for existing currency with same numeric code but different alphabetic code
        if let existingByNumeric = registry[.numeric(currency.numericCode)]?.currency,
           existingByNumeric.alphabeticCode != currency.alphabeticCode {
            // Remove the orphaned alphabetic entry
            registry[.alphabetic(existingByNumeric.alphabeticCode)] = nil
        }

        // Check for existing currency with same alphabetic code but different numeric code
        if let existingByAlphabetic = registry[.alphabetic(currency.alphabeticCode)]?.currency,
           existingByAlphabetic.numericCode != currency.numericCode {
            // Remove the orphaned numeric entry
            registry[.numeric(existingByAlphabetic.numericCode)] = nil
        }

        let value = Value(currency)
        registry[.numeric(currency.numericCode)] = value
        registry[.alphabetic(currency.alphabeticCode)] = value
    }

    /// Unregisters the provided currency with the system.
    ///
    /// Doing so removes the ability to initialize the currency using its numeric or alphabetic code.
    public func unregister(_ currency: ISO4217Currency) {
        registryLock.lock()
        defer { registryLock.unlock() }

        registry[.numeric(currency.numericCode)] = nil
        registry[.alphabetic(currency.alphabeticCode)] = nil
    }

    /// Returns the registered currency for the provided ISO 4217 numeric code.
    public func currency(forNumericCode numericCode: String) -> ISO4217Currency? {
        registryLock.lock()
        defer { registryLock.unlock() }
        return registry[.numeric(numericCode)]?.currency
    }

    /// Returns the registered currency for the provided ISO 4217 alphabetic code.
    public func currency(forAlphabeticCode alphabeticCode: String) -> ISO4217Currency? {
        registryLock.lock()
        defer { registryLock.unlock() }
        return registry[.alphabetic(alphabeticCode)]?.currency
    }
}

// MARK: - ISO4217Currency + Registry

extension ISO4217Currency {
    /// A registry containing ISO 4217 currency codes.
    public static let registry: ISO4217CurrencyRegistry = {
        let registry = ISO4217CurrencyRegistry()
        for currency in ISO4217Currency.predefinedISO4217Currencies {
            registry.register(currency)
        }

        return registry
    }()
}

// MARK: ISO4217Currency + Code Initializer

extension ISO4217Currency {
    /// Initializes an ISO 4217 currency associated with a given alphabetic code.
    ///
    /// Currency codes are checked according to a strict, case-sensitive equality comparison.
    /// This initializer first checks predefined ISO 4217 currencies, then checks any registered custom currencies.
    ///
    /// - Parameter alphabeticCode: The alphabetic ISO 4217 currency code
    init?(alphabeticCode: String, using registry: ISO4217CurrencyRegistry = Self.registry) {
        guard let currency = registry.currency(forAlphabeticCode: alphabeticCode) else {
            return nil
        }

        self = currency
    }

    /// Initializes an ISO 4217 currency associated with a given numeric code.
    ///
    /// This initializer first checks predefined ISO 4217 currencies, then checks any registered custom currencies.
    ///
    /// - Parameter numericCode: The numeric ISO 4217 currency code
    init?(numericCode: String, using registry: ISO4217CurrencyRegistry = Self.registry) {
        guard let currency = registry.currency(forNumericCode: numericCode) else {
            return nil
        }

        self = currency
    }
}
