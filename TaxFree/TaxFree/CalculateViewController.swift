//
//  CalculateViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 24/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var choosedValue: Double = 0.0
    var choosedDescription = ""
    var choosedCountry = ""
    var choosedCurrency: String = ""
    var indexOfCountry: Int = 0
    var minimumPurchase: Double = 0
    var currencies: [String] = []
    var textViewString = ""

    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyCodeCustom: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var textViewLabel: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyCodeResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewLabel.addTarget(self, action: #selector(CalculateViewController.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        
        textViewLabel.becomeFirstResponder()
        self.currencyCodeLabel.text = choosedCountry
        self.currencyCodeResult.text = choosedCurrency
        self.countryLabel.text = choosedDescription
        print(choosedValue)
    }

    func setCornerRadius(label: UILabel) {
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textViewString = self.textViewLabel.text!
        if textViewString != "" {
            self.resultLabel.text = String(format: "%.3f", (Double(textViewString)!/choosedValue))
        } else {
            self.resultLabel.text = "0.0"
        }
    }
}
