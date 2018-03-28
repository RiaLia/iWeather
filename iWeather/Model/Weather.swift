//
//  Weather.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-21.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import Foundation

struct Wind : Codable {
    let speed: Float
    let deg: Float
}

struct Main : Codable {
    let temp: Float
}

struct Sys : Codable {
    let country : String?
}

struct Desc : Codable {
    let description: String?
    let main: String?
}

struct Info : Codable {
    let weather: [Desc]
    let main : Main
    let dt_txt : String?
    let wind : Wind
    let name : String?
    let sys : Sys
    
}

struct WeatherResponse: Codable {
    let list: [Info]
}

struct CityResponse: Codable {
    let count : Int
    let list : [Info]
} 
