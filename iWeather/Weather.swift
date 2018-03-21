//
//  Weather.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-03-21.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import Foundation


struct Main : Codable {
    let temp: Float
}

struct Desc : Codable {
    let description: String?
    let main: String?
}

struct Info : Codable {
    let weather: [Desc]
    let main : Main
    let dt_txt : String?
}

struct WeatherResponse: Codable {
    let list: [Info]
}

