//
//  ViewController.swift
//  iOS_Rahul_Panzade_Assignment_For_Webonise
//
//  Created by Rahul Panzade on 10/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreLocation

class WeatherController: UIViewController {
    // MARK:- Variables
    let APP_ID = "77b1474ffd78f08533f15f8bf556d24f"
    let UPDATE_LIST_DISTANCE_IN_METRE = 10.0
    var weatherArry = [WeatherModel]()
    let locationManager = CLLocationManager()
    var lastLocation : CLLocation!
    
    // MARK:- Outlets
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var lblForLatitude : UILabel!
    @IBOutlet weak var lblForLongitude : UILabel!
    @IBOutlet weak var loader : UIActivityIndicatorView!
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.locationManager.delegate = self
        if checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Used to start loader
    func startLoader() {
        self.loader.isHidden = false
        self.loader.startAnimating()
    }
    /// used to stop loader
    func stopLoader(){
        self.loader.stopAnimating()
        self.loader.isHidden = true
    }
    
    /// Used to get weather data from server
    ///
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    func callToGetWeatherData(with latitude : Double , longitude: Double){
        self.startLoader()
        self.lblForLatitude.text = "Latitude : \(latitude)"
        self.lblForLongitude.text = "Logitude : \(longitude)"
        
        if !isConnectedToNetwork(){
            presentNetworkAlert()
            return
        }
        
        APIs.performGet(requestStr: "http://api.openweathermap.org/data/2.5/find", query: "lat=\(latitude)&lon=\(longitude)&cnt=10&appid=\(APP_ID)") { (data) in
            if let dataDict = data as? NSDictionary{
                print(dataDict)
                guard let dataArray = dataDict.value(forKey: "list") as? NSArray else{return}
                self.weatherArry.removeAll()
                for weatherObj in dataArray{
                    let areaName = (weatherObj as? NSDictionary)?.value(forKey: "name") as? String ?? ""
                    let temp = (((weatherObj as? NSDictionary)?.value(forKey: "main") as? NSDictionary)?.value(forKey: "temp") as! NSNumber).floatValue
                    let humidity = ((weatherObj as? NSDictionary)?.value(forKey: "main") as? NSDictionary)?.value(forKey: "humidity") as? Float ?? 0.0
                    self.weatherArry.append(WeatherModel(areaName: areaName, temp: temp, humidity: humidity))
                }
                self.tableView.reloadData()
                self.stopLoader()
            }else{
                self.stopLoader()
            }
        }
    }
    
    /// Used to check user permision
    ///
    /// - Returns: result
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
}

// MARK: - UITableViewDataSource
extension WeatherController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        cell.configure(weatherData: weatherArry[indexPath.row])
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate.longitude)
            if self.lastLocation == nil{
                self.lastLocation = locations.last
                self.callToGetWeatherData(with: coordinate.latitude, longitude: coordinate.longitude)
            }
            if lastLocation.distance(from: locations.last!) > UPDATE_LIST_DISTANCE_IN_METRE{
                self.lastLocation = locations.last
                self.callToGetWeatherData(with: coordinate.latitude, longitude: coordinate.longitude)
            }
            
        }
    }
}

// MARK: - Network check
extension WeatherController {
    /// Used to check connectivity
    ///
    /// - Returns: flag
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let isConnected = (isReachable && !needsConnection)
        
        return isConnected
    }
    
    /// Used to present network error alert
    func presentNetworkAlert(){
        stopLoader()
        let alertVc = UIAlertController(title: "No Internet!", message: "No internet available. Please check your connection.", preferredStyle: UIAlertController.Style.alert)
        alertVc.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertVc, animated: true, completion: nil)
    }
}
