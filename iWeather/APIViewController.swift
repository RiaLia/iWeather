//
//  APIViewController.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-15.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class APIViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var conditionText: UILabel!
    @IBOutlet weak var temperaturText: UILabel!
    
    
    @IBOutlet weak var dateText2: UILabel!
    
    @IBOutlet weak var conditionText2: UILabel!
    
    @IBOutlet weak var temperaturText2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func search(_ sender: Any) {
        if let safeString = searchText.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
                                self.dateText.text = weatherResponse.list[0].dt_txt
                                self.conditionText.text = "Weather condition: \(weatherResponse.list[0].weather[0].description!)"
                                self.temperaturText.text = "Temp is \(weatherResponse.list[0].main.temp)°C"
                               // Second
                                self.dateText2.text = weatherResponse.list[4].dt_txt
                                self.conditionText2.text = "Weather condition: \(weatherResponse.list[4].weather[0].description!)"
                                self.temperaturText2.text = "Temp is \(weatherResponse.list[4].main.temp)°C"
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

}
