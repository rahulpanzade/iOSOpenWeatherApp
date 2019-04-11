//
//  WeatherModel.swift
//  iOS_Rahul_Panzade_Assignment_For_Webonise
//
//  Created by Rahul Panzade on 11/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
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
