//
//  ViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 18/06/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit
import Toast_Swift
import StoreKit
import DKChainableAnimationKit

class ViewController: UIViewController {
    
    public var dict: [String : AnyObject] = [:]
    
    let runIncrementerSetting = "numberOfRuns"
    let minimumRunCount = 3
    var namesArray: [String] = ["EUR", "USD", "GPB", "BYN", "BGN", "DKK", "KZT", "CHF", "JPY"]
    var i = 0
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var currencyConverterLabel: UILabel!
    @IBOutlet weak var calculatorImage: UIImageView!
    @IBOutlet weak var vatCountryRulesView: UIView!
    @IBOutlet weak var calculateView: UIView!
    @IBOutlet weak var countryRulesButton: UIButton!
    @IBOutlet weak var refundCalcButton: UIButton!
    @IBOutlet weak var animateLabel: UILabel!
    @IBOutlet weak var calculateSubLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyConverterLabel.text = Utils().getLocalizeString(key: "currency_converter")
        self.subTitleLabel.text = Utils().getLocalizeString(key: "sub_title_cc")
        self.animateLabel.text = Utils().getLocalizeString(key: "welcome")
        self.refundCalcButton.setTitle(Utils().getLocalizeString(key: "calculator"), for: .normal)
        self.calculateSubLabel.text = Utils().getLocalizeString(key: "sub_calculator")
        self.incrementAppRuns()
//        self.showReview() // comment out before review
        self.addBoundsView(viewElement: vatCountryRulesView)
        self.addBoundsView(viewElement: calculateView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateLabelios()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    @IBAction func calculateButtonClicked(_ sender: Any) {
        if (Utils().getValueFromDefaults(key: "json_object") != nil) {
            UIView.animate(withDuration: 0.4, animations: {
                self.calculateView.frame.origin.y += 1000
            }, completion: { _ in
                self.performSegue(withIdentifier: "choose_your_country", sender: self)
                UIView.animate(withDuration: 2.5) {
                    self.calculateView.frame.origin.y -= 1000
                }
            })
        } else {
            self.view.makeToast("something went wrong!")
        }
    }

    func addBoundsView(viewElement: UIView) {
        viewElement.layer.masksToBounds = true
        viewElement.layer.cornerRadius = 5
        viewElement.layer.borderWidth = 0.45
        viewElement.layer.borderColor = UIColor.white.cgColor
    }
    
    func addBorderButton(button: UIButton) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.blue.cgColor
    }
    
    func animateLabelios() {
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 12.0, repeats: true) {_ in
                self.animateLabel.text = self.namesArray[self.i]
                if self.i < self.namesArray.count - 1 {
                    self.i += 1
                } else {
                    self.i = 0
                }
                self.animateLabel.center.x = self.view.center.x
                self.animateLabel.center.x -= self.view.bounds.width
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                    self.animateLabel.center.x += self.view.bounds.width
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func showToastActivityIndicator() {
        var style = ToastStyle()
        style.activitySize = (CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        ToastManager.shared.style = style
        self.view.makeToastActivity(.center)
    }
    
    func hideToastActivityIndicator() {
        self.view.hideToastActivity()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func incrementAppRuns() {
        let usD = UserDefaults()
        let runs = getRunCounts() + 1
        usD.setValuesForKeys([runIncrementerSetting: runs])
        usD.synchronize()
    }
    
    func getRunCounts () -> Int {
        let usD = UserDefaults()
        let savedRuns = usD.value(forKey: runIncrementerSetting)
        var runs = 0
        if (savedRuns != nil) {
            runs = savedRuns as! Int
        }
        print("Run Counts are \(runs)")
        return runs
    }
    
    func showReview() {
        let runs = getRunCounts()
        print("Show Review")
        if (runs > minimumRunCount) {
            if #available(iOS 10.3, *) {
                print("Review Requested")
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        } else {
            print("Runs are not enough to request review!")
        }
    }
}

