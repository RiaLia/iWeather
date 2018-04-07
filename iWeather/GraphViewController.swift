//
//  GraphViewController.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-04-03.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit
import GraphKit
import Charts

class GraphViewController: UIViewController, GKBarGraphDataSource {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityCompare: UITextField!
    @IBOutlet weak var barChartView: GKBarGraph!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    
    @IBOutlet weak var newCityLabel: UILabel!
    
    var currentCity : String = ""
    var currentTemp : Int? = 0
    var currentWind : Int? = 0
    var currentHumidity : Int = 0
    
    var newTemp : Int? = 0
    var newWind : Int? = 0
    var newHumidity : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = currentCity
        barChartView.dataSource = self
       
    }
    
    func numberOfBars() -> Int {
        return 8
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        if index == 2 {
            return 0
        } else if index == 5 {
            return 0
        } else {
            
            switch index {
            case 0 :
                return currentTemp! * 2 as NSNumber
            case 1 :
                return newTemp! * 2 as NSNumber
            case 3 :
                return currentWind! * 2 as NSNumber
            case 4 :
                return newWind! * 2 as NSNumber
            case 6 :
                return currentHumidity as NSNumber
            case 7 :
                return newHumidity as NSNumber
                
            default:
                return (index + 1) * 2 as NSNumber
            }
        }
    }
    
    func titleForBar(at index: Int) -> String! {
        if index == 2 || index == 5 {
            return ""
        } else {
           
            switch index {
            case 0 :
                return "\(String(describing: currentTemp!))"
            case 1 :
                return "\(String(describing: newTemp!))"
            case 3 :
                return "\(String(describing: currentWind!))"
            case 4 :
                return "\(String(describing: newWind!))"
            case 6 :
                return "\(String(describing: currentHumidity))"
            case 7 :
                return "\(String(describing: newHumidity))"
 
            default:
                return nil
            }
        }
    }
    
    func colorForBar(at index: Int) -> UIColor! {
        return [UIColor.purple, UIColor.black, UIColor.gray][index % 3]
    }
    
    func colorForBarBackground(at index: Int) -> UIColor! {
        return UIColor.lightGray
    }
    
 
   
    @IBAction func compare(_ sender: Any) {
        
        let searchText = cityCompare.text
        if let safeString = searchText?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
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
                               
                                self.newTemp = Int(weatherResponse.list[0].main.temp)
                                self.newWind = Int(weatherResponse.list[0].wind.speed)
                                self.newHumidity = weatherResponse.list[0].main.humidity
                                self.currentCityLabel.text = self.currentCity
                                self.newCityLabel.text = searchText
                                
                                self.barChartView.draw()
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
