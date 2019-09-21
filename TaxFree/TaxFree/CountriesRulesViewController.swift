//  CountriesRulesViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 25/08/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class CountriesRulesViewController: UITableViewController, UISearchBarDelegate {
    
    let countriesArray = ["Austria", "Czech_Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Iceland", "Ireland", "Italy"]
    var filteredData: [String]!
    var choosedCell: String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
        filteredData = countriesArray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_info_vc" {
            if let nextViewController = segue.destination as? InfoViewController {
                nextViewController.choosedCountry = self.choosedCell
            }
        }
    }

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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosedCell = filteredData[indexPath.row]
        self.performSegue(withIdentifier: "to_info_vc", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? countriesArray : countriesArray.filter { (item: String) -> Bool in
            
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.searchBar.barStyle = .default
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
