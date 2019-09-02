//
//  Utils.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 27/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class Utils: NSObject {
    func getValueFromDefaults(key: String) -> Any! {
        return UserDefaults.standard.value(forKey: key) as Any?
    }
    
    func saveValueForDefaults(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
