//
//  GetWeather.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-24.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class GetWeather: NSObject {
    var info : [String : Any] = [:]
    var searchResult : [String] = []
  

    func getCity(searchText: String) {
        
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
                            
                            
                            for x in 0..<cityResponse.count {
                                self.searchResult.append(weatherResponse.list[x].name! + ", " + weatherResponse.list[x].sys.country!)
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
    
    func getInfo(searchText: String, type: String, indexPath: Int) {
        
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
                            let weatherResponse = try decoder.decode(WeatherResponse.self, from: actualData)
                            
                           //  let cityResponse = try decoder.decode(CityResponse.self, from: actualData)
                            
                            
                                let date = weatherResponse.list[indexPath].dt_txt
                                let desc = weatherResponse.list[indexPath].weather[0].description
                                let main = weatherResponse.list[indexPath].weather[0].main
                                let temp = weatherResponse.list[indexPath].main.temp
                                let windSpeed = weatherResponse.list[indexPath].wind.speed
                                let windDeg = weatherResponse.list[indexPath].wind.deg
                            
                            
                                self.info["Date"] = [date!]
                                self.info["Desc"] = [desc!]
                                self.info["Main"] = [main!]
                                self.info["Temp"] = [temp]
                                self.info["WindSpeed"] = [windSpeed]
                                self.info["WindDeg"] = [windDeg]
                            
                                print(self.info)
                            
                             //self.icon.image = UIImage(named: weatherDesc!)
                              //  let number = cityResponse.count
                            
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








/*
func getCity(searchText: String){
    
    
    if let safeString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: "https://andruxnet-world-cities-v1.p.mashape.com/?query=\(safeString)&searchby=city&X-Mashape-Key=creW8gdJKDmshsrPTtmkAbw0EQjpp1lBb0tjsnRRJTVkqZA0g9&Accept=application/json")
          //  .header("X-Mashape-Key", "creW8gdJKDmshsrPTtmkAbw0EQjpp1lBb0tjsnRRJTVkqZA0g9")
           // .header("Accept", "application/json")
          //  .asJson()
    {
        
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
                        print(weatherResponse)
                        //  let cityResponse = try decoder.decode(CityResponse.self, from: actualData)
                        
                        
                        
                        //self.icon.image = UIImage(named: weatherDesc!)
                        
                        
                        //  let number = cityResponse.count
                        
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

    Get CITY
 // These code snippets use an open-source library. http://unirest.io/objective-c
 NSDictionary *headers = @{@"X-Mashape-Key": @"creW8gdJKDmshsrPTtmkAbw0EQjpp1lBb0tjsnRRJTVkqZA0g9", @"Accept": @"application/json"};
 UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
 [request setUrl:@"https://andruxnet-world-cities-v1.p.mashape.com/?query=paris&searchby=city"];
 [request setHeaders:headers];
 }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
 NSInteger code = response.code;
 NSDictionary *responseHeaders = response.headers;
 UNIJsonNode *body = response.body;
 NSData *rawBody = response.rawBody;
 }];
 */
