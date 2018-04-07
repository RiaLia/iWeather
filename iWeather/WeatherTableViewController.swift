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
    
    var currentWeatherCondition : String? = ""
    var currentDesc : String? = ""
    var currentTemp : Int? = 0
    var currentWind : Int? = 0
    var currentHumidity : Int? = 0
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
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
    
            searchResult = getCity(searchText: text, type: "find")
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
            cell.currentTemp = currentTemp!
            cell.currentWeatherCondition = currentWeatherCondition!
            cell.currentWind = currentWind!
            cell.currentHumidity = currentHumidity
            
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
                                   
                                    let desc = weatherResponse.list[0].weather[0].description
                                    cell.descText.text = desc?.uppercased()
                                    
                                    cell.currentWeatherCondition = weatherResponse.list[0].weather[0].main
                                    cell.iconImage.image = UIImage(named: cell.currentWeatherCondition!)
                                    
                                    cell.currentTemp = Int(weatherResponse.list[0].main.temp)
                                    cell.tempField.text = "\(cell.currentTemp!)°C"
                                    
                                    cell.currentWind = Int(weatherResponse.list[0].wind.speed)
                                    cell.windText.text = "\(String(describing: cell.currentWind!)) M/S"
                                    
                                    cell.currentHumidity = weatherResponse.list[0].main.humidity
                                    
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
    
    
    func getCity(searchText: String, type: String) -> [String] {
        
        
        if let safeString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.openweathermap.org/data/2.5/\(type)?q=\(safeString)&units=metric&APPID=3eacf70234b1d42777fea0c6f2ad9ee0") {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:
            { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        let decoder = JSONDecoder()
                        do{
                            
                            self.searchResult = []
                            
                           
                                let cityResponse = try decoder.decode(CityResponse.self, from: actualData)
                            
                                DispatchQueue.main.async {
                                    if self.useSearchResult {
                                        
                                    for x in 0..<cityResponse.count {
                                        self.searchResult.append(cityResponse.list[x].name! + ", " + cityResponse.list[x].sys.country!)
                                        
                                        self.currentTemp = Int(cityResponse.list[0].main.temp)
                                        self.currentWind = Int(cityResponse.list[0].wind.speed)
                                        self.currentHumidity = cityResponse.list[0].main.humidity
                                        self.currentWeatherCondition = cityResponse.list[0].weather[0].main
                                    }
                                    self.tableView.reloadData()
                                    
                                        
                                    } 
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
                let tabBarController = segue.destination as! UITabBarController
                let firstVC = tabBarController.viewControllers![0]
                tabBarController.tabBar.tintColor = UIColor.white
                
                let nextVc:DetailViewController = firstVC as! DetailViewController
                nextVc.favorites = favorites
                nextVc.passingCityText = cell.cityId!
                
                let secVC = tabBarController.viewControllers![1]
                let nextSec : RecViewController = secVC as! RecViewController
                nextSec.test = cell.cityId
                nextSec.currentWeatherCondition = cell.currentWeatherCondition
                nextSec.currentTemp = cell.currentTemp
                nextSec.currentWind = cell.currentWind
                
                let thirdVC = tabBarController.viewControllers![2]
                let nextThird : GraphViewController = thirdVC as! GraphViewController
                nextThird.currentCity = cell.cityId!
                nextThird.currentTemp = cell.currentTemp
                nextThird.currentWind = cell.currentWind
                nextThird.currentHumidity = cell.currentHumidity!
                
            }
        } else if segue.identifier == "citySend" {
            if let cell = sender as? CustomCityTableCell{
                
                let tabBarController = segue.destination as! UITabBarController
                let firstVC = tabBarController.viewControllers![0]
                tabBarController.tabBar.tintColor = UIColor.white
                
                let nextVc:DetailViewController = firstVC as! DetailViewController
                nextVc.favorites = favorites
                nextVc.passingCityText = cell.cityId!
                
                let secVC = tabBarController.viewControllers![1]
                let nextSec : RecViewController = secVC as! RecViewController
                nextSec.test = cell.cityId
                nextSec.currentWeatherCondition = cell.currentWeatherCondition
                nextSec.currentTemp = cell.currentTemp
                nextSec.currentWind = cell.currentWind
                
                let thirdVC = tabBarController.viewControllers![2]
                let nextThird : GraphViewController = thirdVC as! GraphViewController
                nextThird.currentCity = cell.cityId!
                nextThird.currentTemp = cell.currentTemp
                nextThird.currentWind = cell.currentWind
                nextThird.currentHumidity = cell.currentHumidity!
            }
        }
    }
}


 

