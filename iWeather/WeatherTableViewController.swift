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
    
    var favorites : [String] = []
    var searchResult : [String] = []
    var searchController : UISearchController!
    var defaults = UserDefaults.standard
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        
       // let myApi = GetWeather()
      //  myApi.getInfo(searchText: "Los Angeles", type: "forecast", indexPath: 0)
       // myApi.getCity()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let maybeFavorites = defaults.stringArray(forKey: "Favorites") {
            favorites = maybeFavorites
        } else {
            favorites = []
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.becomeFirstResponder()  
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
    
            searchResult = getCity(searchText: text)
            
            // För att kunna för upp samtliga städer och sen filtrera dessa, så behövs det läsas in en lista med samtliga städer.
            
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !useSearchResult {
            if section == 0 {
                return "Favorites"
            } else if section == 1 {
                return "Senaste"
            }
        } else {
            
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if useSearchResult {
            return searchResult.count
        } else {
        return favorites.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if useSearchResult {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CustomCityTableCell
            
            cell.cityId = searchResult[indexPath.row]
            cell.cityText.text = searchResult[indexPath.row]
            
            return cell
            
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableCell

        cell.cityId = favorites[indexPath.row]
        let currentCity = favorites[indexPath.row]
        cell.cityText.text = currentCity
        
            if let safeString = currentCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(safeString)&units=metric&APPID=3eacf70234b1d42777fea0c6f2ad9ee0") {
                
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request, completionHandler:
                { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    if let actualError = error {
                        print(actualError)
                    } else {
                        if let actualData = data {
                            
                            let decoder = JSONDecoder()
                            
                            do{
                                let weatherResponse = try decoder.decode(WeatherResponse.self, from: actualData)
                                
                                DispatchQueue.main.async {
                                   
                                    let weatherDesc = weatherResponse.list[0].weather[0].main
                                    cell.iconImage.image = UIImage(named: weatherDesc!)
                                    cell.tempField.text = "\(Int(weatherResponse.list[0].main.temp))°C"
                                    cell.windText.text = String(weatherResponse.list[0].wind.speed)
                                    
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
        return cell
        }
    }
    
    
    func getCity(searchText: String) -> [String] {
        
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
                                    self.searchResult.append(weatherResponse.list[x].name! + ", " + weatherResponse.list[x].sys.country!)
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
                let nextVc:DetailViewController = segue.destination as! DetailViewController
                nextVc.favorites = favorites
                nextVc.passingCityText = cell.cityId!
            }
        } else if segue.identifier == "citySend" {
            if let cell = sender as? CustomCityTableCell{
                let nextVc:DetailViewController = segue.destination as! DetailViewController
                nextVc.favorites = favorites
                nextVc.passingCityText = cell.cityId!
            }
        }
    }
}


 

