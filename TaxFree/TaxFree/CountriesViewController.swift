//
//  CountriesViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 24/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {
    
    let countriesArray = ["RUB", "KZT", "BYN", "UAH", "CNY"]
    let countriesDetail = ["Russia", "Kazakhstan", "Belarus", "Ukraine", "China"]
    var filteredData: [String]!
    var choosedCell: String = ""
    
    @IBOutlet weak var closeItemButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = countriesArray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_choose_currency_vc" {
            if let nextViewController = segue.destination as? ChooseCurrencyViewController {
                nextViewController.choosedCountry = self.choosedCell
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        let image = UIImage(named: "\(filteredData[indexPath.row])")
        cell.imageView?.image = image?.circleMask
        cell.textLabel?.text = self.filteredData[indexPath.row]
        cell.detailTextLabel?.text = self.countriesDetail[indexPath.row]
        cell.detailTextLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosedCell = filteredData[indexPath.row]
        self.performSegue(withIdentifier: "to_choose_currency_vc", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? countriesArray : countriesArray.filter { (item: String) -> Bool in
            
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    var circleMask: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}
