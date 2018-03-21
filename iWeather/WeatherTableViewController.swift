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
    

    //let cities = ["Göteborg", "Stockholm", "Malmö", "Sundsvall", "Karlstad"]
    let weather = ["Clear", "Rain", "Snow", "Thunder", "SemiSunny" ]
    var searchResult : [String] = []
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController

    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.becomeFirstResponder()
    }

    // Moas tjusiga sök loop!
    
    // for x in 0..<weatherResponse {
    // searchResulalt.append(weatherResponse.list[x].name)
    

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
           // searchResult = cities.filter { $0.lowercased().contains(text) }
            // anropa någon metod, tex get weather.
            searchResult = getWeather(searchText: text)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if useSearchResult {
            return searchResult.count
        } else {
        return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableCell

        let array : [String]
        
        if useSearchResult {
            array = searchResult
        } else {
            array = []
        }
        cell.cityId = array[indexPath.row]
        cell.cityText.text = array[indexPath.row]
       // let weatherStatus = weather[indexPath.row]
        //cell.descText.text = weatherStatus
       // cell.iconImage.image = UIImage(named: weatherStatus)
        

        return cell
    }
    
    func getWeather(searchText: String) -> [String] {
        // Göt API Anrop här, byt ut forecast/weather till find
        // Använd moas metod för att filtrera
        
        if let safeString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.openweathermap.org/data/2.5/find?q=\(safeString)&APPID=3eacf70234b1d42777fea0c6f2ad9ee0") {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:
            { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        
                        let decoder = JSONDecoder()
                        
                        do{
                            let cityResponse = try decoder.decode(CityResponse.self, from: actualData)
                            let weatherResponse = try decoder.decode(WeatherResponse.self, from: actualData)
                            
                            DispatchQueue.main.async {
                                
                                self.searchResult = []
                                for x in 0..<cityResponse.count {
                                    self.searchResult.append(weatherResponse.list[x].name!)
                                }
                                self.tableView.reloadData()
                            }
                        } catch let e {
                            print("Error parsing json: \(e)")
                        }
                    } else {
                        print("Data was nil")
                    }
                }
            })
            
            task.resume()
            
        } else {
            print("Didn't work")
        }
        return searchResult
    }
        
    
    
    // MARK: - Navigation
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "sendToDetail" {
            if let cell = sender as? CustomTableCell{
                let selectedRow = self.tableView.indexPathForSelectedRow!.row
                let nextVc:DetailViewController = segue.destination as! DetailViewController
                nextVc.rowId = selectedRow
                nextVc.passingCityText = cell.cityId!
            }
        }
    }
}


 

