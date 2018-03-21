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
        
    var rowId : Int?
    var passingCityText = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityText.text = passingCityText

        // Do any additional setup after loading the view.
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
                                let i = indexPath.row
                                cell.date.text = weatherResponse.list[i].dt_txt
                                cell.temp.text = "\(Int(weatherResponse.list[i].main.temp))°C"
                                let weatherStatus = weatherResponse.list[i].weather[0].main
                                cell.icon.image = UIImage(named: weatherStatus!)
                                //print(weatherStatus!)
                               
                              
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
    
    
    @IBAction func search(_ sender: Any) {
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
                                // First
                             /*   self.dateText.text = weatherResponse.list[0].dt_txt
                                self.conditionText.text = "Weather condition: \(weatherResponse.list[0].weather[0].description!)"
                                self.temperaturText.text = "Temp is \(weatherResponse.list[0].main.temp)°C"
                                // Second
                                self.dateText2.text = weatherResponse.list[4].dt_txt
                                self.conditionText2.text = "Weather condition: \(weatherResponse.list[4].weather[0].description!)"
                                self.temperaturText2.text = "Temp is \(weatherResponse.list[4].main.temp)°C"
 
 */
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
