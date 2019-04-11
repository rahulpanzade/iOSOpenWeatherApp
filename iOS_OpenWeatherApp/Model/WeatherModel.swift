//
//  WeatherModel.swift
//  iOS_OpenWeatherApp
//
//  Created by Rahul Panzade on 11/04/19.
//

import Foundation

/// Weather data model
struct WeatherModel {
    let areaName : String?
    let temp : Float?
    let humidity : Float?
    
    init(areaName : String, temp : Float, humidity : Float) {
        self.areaName = areaName
        self.temp = temp
        self.humidity = humidity
    }
}
