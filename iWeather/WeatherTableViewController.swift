//
//  WeatherTableViewController.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-13.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cities = ["Göteborg", "Stockholm", "Malmö", "Sundsvall", "Karlstad"]
    let weather = ["Sun", "Rain", "Snow", "Thunder", "SemiSunny" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableCell

        let cityName = cities[indexPath.row]
        cell.cityText.text = cityName
        let weatherStatus = weather[indexPath.row]
        cell.descText.text = weatherStatus
        cell.iconImage.image = UIImage(named: weatherStatus)

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       // if segue.identifier == "sendToDetail" {}
        if segue.identifier == "sendToDetail" {
            var selectedRow = self.tableView.indexPathForSelectedRow
            let nextVc:DetailViewController = segue.destination as! DetailViewController
            nextVc.rowId = selectedRow!.row
            nextVc.passingCityText = cities[selectedRow!.row]
        }
    

    }
}
