//
//  ChooseCurrencyViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 27/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class ChooseCurrencyViewController: UITableViewController {
    
    var choosedValue: Double = 0.0
    var choosedDescription : String = ""
    var choosedCountry: String = ""
    var json = [String:AnyObject]()
    var jsonCodes = [String:AnyObject]()
    var valuteNameArray: [String] = []
    var charCodeArray: [String] = []
    var valueArray: [Double] = []
    var choosedCell = ""
    var filteredDataCurrency: [String]!
    var valueK: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Utils().getLocalizeString(key: "top_item_text")
        self.createRightButtonItem()
        
        json = (Utils().getValueFromDefaults(key: "json_object")) as! Dictionary<String, AnyObject>
        
        if let title = json["Valute"] {
            jsonCodes = title as! Dictionary<String, AnyObject>
            for i in jsonCodes.keys.sorted(by: { $0 < $1 }) {
                if let valueContainer = jsonCodes[i] {
                    if let charCode = valueContainer["CharCode"] {
                        charCodeArray.append(charCode as! String)
                    }
                    if let name = valueContainer["Name"] {
                        valuteNameArray.append(name as! String)
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
        filteredDataCurrency = valuteNameArray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_calculate_vc" {
            if let nextViewController = segue.destination as? CalculateViewController {
                nextViewController.choosedCurrency = choosedCell
                nextViewController.choosedCountry = choosedCountry
                nextViewController.choosedDescription = choosedDescription
                nextViewController.choosedValue = choosedValue
                nextViewController.valueK = valueK
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataCurrency.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        self.removeCountry()
        
        let image = UIImage(named: "\(charCodeArray[indexPath.row])")
        cell.imageView?.image = image?.circleMask
        cell.textLabel?.text = Utils().getLocalizeString(key: filteredDataCurrency[indexPath.row])
        cell.detailTextLabel?.text = charCodeArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosedDescription = filteredDataCurrency[indexPath.row]
        choosedCell = charCodeArray[indexPath.row]
        choosedValue = valueArray[indexPath.row]
        self.performSegue(withIdentifier: "to_calculate_vc", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func removeCountry() {
        if (choosedCountry != "RUB") {
            self.chooseIndex(index: self.findNeededElement())
        }
    }
    
    func findNeededElement() -> Int {
        for i in charCodeArray {
            if choosedCountry == "KZT" && i == "KZT" {
                return charCodeArray.firstIndex(of: "KZT")!
            }
            if choosedCountry == "BYN" && i == "BYN" {
                return charCodeArray.firstIndex(of: "BYN")!
            }
            if choosedCountry == "UAH" && i == "UAH" {
                return charCodeArray.firstIndex(of: "UAH")!
            }
            if choosedCountry == "CNY" && i == "CNY" {
                return charCodeArray.firstIndex(of: "CNY")!
            }
        }
        return charCodeArray.firstIndex(of: "RUB")!
    }
    
    func chooseIndex(index: Int) {
        let i = valueArray.remove(at: index)
        valueK = i
        valueArray.insert(i, at: index)
        charCodeArray.remove(at: index)
        charCodeArray.insert("RUB", at: index)
        filteredDataCurrency.remove(at: index)
        filteredDataCurrency.insert("Российский рубль", at: index)
    }
    
    func createRightButtonItem() {
        self.navigationItem.leftBarButtonItem = nil
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "Star-Full.png"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
        button.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        let barButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [barButtonItem]
    }
    
    @objc func addTapped() {
        let favouritesVc = storyboard?.instantiateViewController(withIdentifier: "favourites_vc") as! FavouritesViewController
        present(favouritesVc, animated: true, completion: nil)
    }
}
