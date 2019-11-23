//
//  UtilsKeys.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 10.11.2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import Foundation

// MARK: - Global URL
struct Domain {
    static let JSON_DATA_URL = "https://www.cbr-xml-daily.ru/daily_json.js"
}

// MARK: - Keys objects
struct GlobalKeys {
    static let JSON_OBJECT = "json_object"
    static let JSON_SAVED_ARRAY = "saved_array"
}

struct SegueID {
    static let CHOOSED_COUNTRY = "choose_your_country"
    static let CALCULATE_VC = "to_calculate_vc"
    static let CALCULATE_FROM_FAVOURITES = "to_calculate_vc_from_fav"
    static let TO_FAVOURITE_VC = "to_favourite_vc"
}

struct CountriesVC {
    static let COUNTRIES_ARRAY = ["RUB", "KZT", "BYN", "UAH", "CNY"]
}
