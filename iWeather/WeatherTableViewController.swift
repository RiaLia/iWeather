//
//  WeatherTableViewController.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-13.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchResultsUpdating {
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cities = ["Göteborg", "Stockholm", "Malmö", "Sundsvall", "Karlstad"]
    let weather = ["Sun", "Rain", "Snow", "Thunder", "SemiSunny" ]
    var searchResult : [String] = []
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController

    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.becomeFirstResponder()
    }

    
    /*
 
 func updateSearchResults(for searchController: UISearchController) {
 if let text = searchController.searchBar.text?.lowercased() {
 searchResult = fruits.filter { $0.lowercased().contains(text) }
 } else {
 searchResult = []
 }
 tableView.reloadData()
 
 } */
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
            searchResult = cities.filter { $0.lowercased().contains(text) }
        }else {
            searchResult = []
        }
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    var useSearchResult : Bool {
        if let text = searchController.searchBar.text {
            if text.isEmpty {
                return false
            } else {
                return searchController.isActive
            }
        } else {
            return false
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if useSearchResult {
            return searchResult.count
        } else {
        return cities.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableCell

        let array : [String]
        
        if useSearchResult {
            array = searchResult
        } else {
            array = cities
        }
        
        cell.cityText.text = array[indexPath.row]
        
        
        
    /*    let cityName = cities[indexPath.row]
        cell.cityText.text = cityName
        let weatherStatus = weather[indexPath.row]
        cell.descText.text = weatherStatus
        cell.iconImage.image = UIImage(named: weatherStatus)  */

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendToDetail" {
            var selectedRow = self.tableView.indexPathForSelectedRow
            let nextVc:DetailViewController = segue.destination as! DetailViewController
            nextVc.rowId = selectedRow!.row
            nextVc.passingCityText = cities[selectedRow!.row]
        }
    

    }
}
