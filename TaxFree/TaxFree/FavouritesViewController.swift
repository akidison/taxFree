//  FavouritesViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 09/09/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
    
    var saved = [String]()
    
    @IBOutlet weak var navigationItemBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItemBar.title = Utils().getLocalizeString(key: "fav_top_item_text")
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
    
    func showToastWithSavedEmpty() {
        Utils().showToastWithCustomtexts(title: "empty_title_msg", message: "empty_title_text", selfView: self.view, imageName: "importante.png", duration: 4.0)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saved.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let image = UIImage(named: "\(saved[indexPath.row])")
        cell.imageView?.image = image?.circleMask
        cell.textLabel?.text = saved[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.saved.remove(at: indexPath.row)
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
