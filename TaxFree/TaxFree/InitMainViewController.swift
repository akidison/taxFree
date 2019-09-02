//
//  InitMainViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 24/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit
import DKChainableAnimationKit
import Toast_Swift

class InitMainViewController: UIViewController {
    
    let progress = Progress(totalUnitCount: 10)
    let jsonUrl = "https://www.cbr-xml-daily.ru/daily_json.js"

    @IBOutlet weak var test: UIView!
    @IBOutlet weak var barProgress: UIProgressView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getJsonData(urlAddress: jsonUrl, result: { finished, error in
            if finished == true && error == nil {
                self.barProgress.alpha = 1.0
                self.test.alpha = 1.0
                self.test.animation.makeCenter(self.view.bounds.width/2, self.view.bounds.height/2).makeScale(3.0).spring.makeOpacity(0.0).animate(3.0).animationCompletion = {
                    self.goToNextView()
                }
            } else {
                self.barProgress.alpha = 0.0
                self.test.alpha = 0.0
                self.showToastInformationError(error: error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.immitationLoad()
    }
    
    func goToNextView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func immitationLoad() {
        barProgress.progress = 0.0
        progress.completedUnitCount = 0
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (timer) in
                guard self.progress.isFinished == false else {
                    timer.invalidate()
                    return
                }
                self.progress.completedUnitCount += 1
                self.barProgress.setProgress(Float(self.progress.fractionCompleted), animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getJsonData(urlAddress: String, result: @escaping (Bool, Error?) -> Void) {
        if (Utils().getValueFromDefaults(key: "json_object") == nil) {
            guard let url = URL(string: urlAddress) else {
                print("Something wrong!")
                self.view.makeToast("Something went wrong!")
                result(false, nil)
                return
            }
            // Asynchronous Http call to your api url, using NSURLSession:
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                // Check if data was received successfully
                if error == nil && data != nil {
                    do {
                        // Convert NSData to Dictionary where keys are of type String, and values are of any type
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                        print(json)
                        result(true, error)
                        Utils().saveValueForDefaults(value: json, key: "json_object")
                        // Access specific key with value of type String
                        // let str = json["key"] as! String
                    } catch {
                        print(error)
                        result(false, error)
                        // Something went wrong
                    }
                } else if error != nil {
                    print(error?.localizedDescription as Any)
                    result(false, error)
                }
            }).resume()
        } else {
            print("user defaults isn't empty")
            result(true, nil)
        }
    }
    
    func showToastInformationError(error: Error?) {
        let defaultErrorMessage = "Try to restart application and check your internet connection!"
        let toastDuration = 1000.0
        var toastStyle = ToastStyle()
        toastStyle.fadeDuration = 0.8
        toastStyle.titleAlignment = .center
        toastStyle.titleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)!
        toastStyle.messageAlignment = .center
        toastStyle.messageFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!
        let toastManager = ToastManager.self
        toastManager.shared.isTapToDismissEnabled = true
        let toastPosition = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)

        self.view.makeToast("Something went wrong! \(defaultErrorMessage)\nError: \(error?.localizedDescription ?? "unidentified error")", duration: toastDuration, point: toastPosition, title: "Warning", image: nil, style: toastStyle) { (_) in
            self.showToastInformationError(error: error)
        }
    }

}
