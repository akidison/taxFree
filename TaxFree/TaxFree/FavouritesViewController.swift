//
//  FavouritesViewController.swift
//  TaxFree
//
//  Created by Andrey Kiselev on 09/09/2019.
//  Copyright © 2019 Andrey Kiselev. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
    
    var favouritesCUrrency: [String] = []
    
    @IBOutlet weak var navigationItemBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItemBar.title = Utils().getLocalizeString(key: "fav_top_item_text")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)


        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
