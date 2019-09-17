//
//  CalculateViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 24/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController, UITextFieldDelegate {
    
    var choosedValue: Double = 0.0
    var choosedDescription = ""
    var choosedCountry = ""
    var choosedCurrency: String = ""
    var indexOfCountry: Int = 0
    var minimumPurchase: Double = 0
    var currencies: [String] = []
    var textViewString = ""
    var isReversed: Bool = false
    var valueK: Double = 0
    var doubleValue: Double = 0

    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyCodeCustom: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var textViewLabel: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyCodeResult: UILabel!
    @IBOutlet weak var reverseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeCursorColor()
        self.createRightButtonItem()
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
        let dotsCount = textViewLabel.text!.components(separatedBy: ".").count - 1
        let commaCount = textViewLabel.text!.components(separatedBy: ",").count - 1
        let number = NumberFormatter().number(from: textViewString)
        if let number = number {
            doubleValue = Double(truncating: number)
        }
        if (dotsCount > 1 || commaCount > 1) {
            textField.text!.removeLast()
        } else {
           self.calculateResult()
        }
    }
    
    func calculateResult() {
        if textViewString != "" {
            if isReversed == false {
                self.calculateWithoutRub()
            } else {
                self.reverseCalculateWithoutRub()
            }
        } else {
            self.resultLabel.text = "0.0"
        }
    }
    
    func reverseCalculateWithoutRub() {
        if self.choosedCountry == "KZT" || self.choosedCountry == "BYN" || self.choosedCountry == "UAH" || self.choosedCountry == "CNY" {
            self.reverseCalculateValueWithDifferentValue()
        } else {
            self.resultLabel.text = String(format: "%.3f", (Double(textViewString)!*choosedValue))
        }
    }
    
    func calculateWithoutRub() {
        if self.choosedCountry == "KZT" || self.choosedCountry == "BYN" || self.choosedCountry == "UAH" || self.choosedCountry == "CNY" {
            self.calculateValueWithDifferentValue()
        } else {
            self.resultLabel.text = String(format: "%.3f", (Double(doubleValue)/choosedValue))
        }
    }
    
    func reverseCalculateValueWithDifferentValue() {
        if choosedCurrency == "RUB" {
            self.resultLabel.text = String(format: "%.3f", (Double(textViewString)!*((1/choosedValue))))
        } else {
            self.resultLabel.text = String(format: "%.3f", (Double(textViewString)!*((1/valueK)*choosedValue)))
        }
    }
    
    func calculateValueWithDifferentValue() {
        if choosedCurrency == "RUB" {
            self.resultLabel.text = String(format: "%.3f", (Double(doubleValue)/((1/choosedValue))))
        } else {
            self.resultLabel.text = String(format: "%.3f", (Double(doubleValue)/((1/valueK)*choosedValue)))
        }
    }
    
    @IBAction func reverseButtonClicked(_ sender: Any) {
        self.textViewLabel.text = ""
        self.resultLabel.text = "0.0"
        let str = self.currencyCodeLabel.text
        if self.isReversed == false {
            self.reverseButton.rotate360Degrees()
            isReversed = true
            self.currencyCodeLabel.text = self.currencyCodeResult.text
            self.currencyCodeResult.text = str
        } else {
            self.reverseButton.rotate360Degrees()
            isReversed = false
            self.currencyCodeLabel.text = self.currencyCodeResult.text
            self.currencyCodeResult.text = str
        }
    }
    
    func animateReverseButton() {
        UIView.animate(withDuration: 0.25) {
            self.reverseButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    func changeCursorColor() {
        UITextField.appearance().tintColor = .white
    }
    
    func createRightButtonItem() {
        self.navigationItem.leftBarButtonItem = nil
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "plusImage.png"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
        button.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        button.addTarget(target, action: #selector(addTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItems = [barButtonItem]
    }
    
    @objc func addTapped() {
        Utils().createCustomToast(toastView: self.view)
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 0.35, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = (delegate as! CAAnimationDelegate)
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
