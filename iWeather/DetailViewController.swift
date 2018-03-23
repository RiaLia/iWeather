//
//  DetailViewController.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-15.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var tempText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var windText: UILabel!
    @IBOutlet weak var windIcon: UIImageView!
    
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    var favorites : [String] = []
    var passingCityText = ""
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        cityText.text = passingCityText
    
        if let maybeFavorites = defaults.stringArray(forKey: "Favorites") {
            favorites = maybeFavorites
        } else {
            favorites = []
        }
        if favorites.contains(passingCityText) {
            favoriteIcon.isHighlighted = true
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        
        if favoriteIcon.isHighlighted {
            favoriteIcon.isHighlighted = false
            
           let itemToRemove = passingCityText
            
            while favorites.contains(itemToRemove) {
                let itemToRemoveIndex = favorites.index(of: itemToRemove)
                    favorites.remove(at: itemToRemoveIndex!)
                    updateFavorite(favo: favorites)
            }
        } else {
            favoriteIcon.isHighlighted = true
            favorites.append(passingCityText)
            updateFavorite(favo: favorites)
        }
    }
    
    func updateFavorite(favo: [String]) {
        defaults.set(favo, forKey: "Favorites")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! CustomDayTableViewCell
        if let safeString = passingCityText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
                                // Header
                                self.dateText.text = weatherResponse.list[0].dt_txt
                                let weatherDesc = weatherResponse.list[0].weather[0].main
                                self.descText.text = weatherDesc
                                self.icon.image = UIImage(named: weatherDesc!)
                                self.tempText.text = "\(Int(weatherResponse.list[0].main.temp))°C"
                                self.windText.text = String(weatherResponse.list[0].wind.speed)
                                //Cell
                                let i = (indexPath.row + 1)
                                cell.date.text = weatherResponse.list[i].dt_txt
                                cell.temp.text = "\(Int(weatherResponse.list[i].main.temp))°C"
                                let weatherStatus = weatherResponse.list[i].weather[0].main
                                cell.icon.image = UIImage(named: weatherStatus!)
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
