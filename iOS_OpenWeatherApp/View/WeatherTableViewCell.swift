//
//  WeatherTableViewCell.swift
//  iOS_Rahul_Panzade_Assignment_For_Webonise
//
//  Created by Rahul Panzade on 10/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    // MARK:- Outlets
    @IBOutlet weak var lblForAreaName : UILabel!
    @IBOutlet weak var lblForAreaTemp : UILabel!
    @IBOutlet weak var lblForAreaHumidity : UILabel!
    
    /// Used configure cell
    ///
    /// - Parameter weatherData: weatherData
    func configure(weatherData : WeatherModel){
        self.lblForAreaName.text = weatherData.areaName
        self.lblForAreaTemp.text = "\(kelvinToCelciusConverte(kelvin: (weatherData.temp ?? 0.0)))°C"
        self.lblForAreaHumidity.text = "\(weatherData.humidity ?? 0.0)"
    }
    //0K − 273.15 = -273.1°C
    /// used to convert kelvin to celcius
    ///
    /// - Parameter kelvin: <#kelvin description#>
    /// - Returns: <#return value description#>
    func kelvinToCelciusConverte(kelvin : Float) -> Float{
        return (kelvin - 273.15)
    }
}
