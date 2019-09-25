//  FavouritesViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 09/09/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
    
    var json = [String:AnyObject]()
    var jsonCodes = [String:AnyObject]()
    var saved = [String]()
    var choosedCurrency = ""
    var choosedName = ""
    var choosedValue: Double = 0.0
    var choosedCountry = ""
    var charCodeArray = [String]()
    var nameArray = [String]()
    var valueArray = [Double]()
    var valueK: Double = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDataFrom()
        self.navigationItem.title = Utils().getLocalizeString(key: "fav_top_item_text")
        if (Utils().getValueFromDefaults(key: "saved_array") != nil) {
            saved = Utils().getValueFromDefaults(key: "saved_array") as! [String]
            if saved.isEmpty {
                self.showToastWithSavedEmpty()
            }
        } else {
            saved = []
            self.showToastWithSavedEmpty()
        }
    }
    
    func getDataFrom() {
        json = (Utils().getValueFromDefaults(key: "json_object")) as! Dictionary<String, AnyObject>
        let savedFavourites = Utils().getValueFromDefaults(key: "saved_array") as! [String]

        if let title = json["Valute"] {
            jsonCodes = title as! Dictionary<String, AnyObject>
            for i in jsonCodes.keys.sorted(by: { $0 < $1 }) {
                if let valueContainer = jsonCodes[i] {
                    if let charCode = valueContainer["CharCode"] {
                        if savedFavourites.contains(charCode as! String) {
                            self.charCodeArray.append(charCode as! String)
                            if let name = valueContainer["Name"] {
                                self.nameArray.append(name as! String)
                            }
                            if let value = valueContainer["Value"] {
                                if let nominal = valueContainer["Nominal"] {
                                    if (nominal as! Int == 100) {
                                        valueArray.append((value as! Double)/100)
                                    } else if (nominal as! Int == 10) {
                                         valueArray.append((value as! Double)/10)
                                    } else {
                                        valueArray.append(value as! Double)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showToastWithSavedEmpty() {
        Utils().showToastWithCustomtexts(title: "empty_title_msg", message: "empty_title_text", selfView: self.view, imageName: "importante.png", duration: 4.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_calculate_vc_from_fav" {
            if let nextViewController = segue.destination as? CalculateViewController {
                nextViewController.choosedCurrency = choosedCurrency
                nextViewController.choosedValue = choosedValue
                nextViewController.choosedDescription = choosedName
                nextViewController.choosedCountry = choosedCountry
                nextViewController.valueK = valueK
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosedCurrency = self.charCodeArray[indexPath.row]
        choosedName = self.nameArray[indexPath.row]
        choosedValue = self.valueArray[indexPath.row]
        self.performSegue(withIdentifier: "to_calculate_vc_from_fav", sender: self)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charCodeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let image = UIImage(named: "\(charCodeArray[indexPath.row])")
        cell.imageView?.image = image?.circleMask
        cell.textLabel?.text = charCodeArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.saved.remove(at: indexPath.row)
            self.charCodeArray.remove(at: indexPath.row)
            Utils().saveValueForDefaults(value: self.saved, key: "saved_array")
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
