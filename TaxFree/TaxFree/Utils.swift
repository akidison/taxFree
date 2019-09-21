//
//  Utils.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 27/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit
import Toast_Swift

class Utils: NSObject {
    func getValueFromDefaults(key: String) -> Any! {
        return UserDefaults.standard.value(forKey: key) as Any?
    }
    
    func saveValueForDefaults(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func showToastWithCustomtexts(title: String, message: String, toastView: UIView) {
        var toastStyle = ToastStyle()
        toastStyle.imageSize = CGSize(width: 20, height: 20)
        toastStyle.fadeDuration = 0.8
        toastStyle.titleAlignment = .left
        toastStyle.titleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)!
        toastStyle.messageAlignment = .left
        toastStyle.messageFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)!
        let toastPosition = CGPoint(x: toastView.bounds.width/2, y: toastView.bounds.height/2)
        toastView.makeToast(Utils().getLocalizeString(key: title), duration: 1.5, point: toastPosition, title: Utils().getLocalizeString(key: message), image: UIImage(named: "importante.png"), style: toastStyle, completion: nil)
    }
    
    func createCustomToast(toastView: UIView) {
        var toastStyle = ToastStyle()
        toastStyle.imageSize = CGSize(width: 20, height: 20)
        toastStyle.fadeDuration = 0.8
        toastStyle.titleAlignment = .left
        toastStyle.titleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)!
        toastStyle.messageAlignment = .center
        toastStyle.messageFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)!
        let toastPosition = CGPoint(x: toastView.bounds.width/2, y: toastView.bounds.height/2)
        toastView.makeToast(Utils().getLocalizeString(key: "toast_message_text_add"), duration: 1.5, point: toastPosition, title: Utils().getLocalizeString(key: "toast_title_text_add"), image: UIImage(named: "success.png"), style: toastStyle, completion: nil)
    }
    
    func getLocalizeString(key: String) -> String {
        let loc = NSLocalizedString(key, comment: "")
        return loc
    }
}
