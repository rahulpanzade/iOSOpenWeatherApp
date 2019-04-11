//
//  APIs.swift
//M-commerce 
//
//  Created by macbook pro on 19/06/18.
//  Copyright © 2018 Omni-Bridge. All rights reserved.
//

import Foundation
import UIKit

class APIs : NSObject{
    /// Used tp perform HTTP GET Method
    ///
    /// - Parameters:
    ///   - requestStr: Request string
    ///   - query: Query string
    ///   - completion: callback block
    static func performGet(requestStr: String, query:String, completion: @escaping (_ data: Any?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlStr = "\(requestStr)?\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let targetURL = URL.init(string: urlStr!)
            let request = NSMutableURLRequest(url: targetURL! as URL)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 15
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if (data != nil) {
                        let json = self.convertDataToJsonObject(data!)
                        completion(json)
                    } else {
                        print(error ?? "error")
                        completion(error)
                    }
                })
                return()
            }
            task.resume()
        }
    }
  
    /// Used to convert data to json
    ///
    /// - Parameter data: data
    /// - Returns: json object
    static func convertDataToJsonObject(_ data:Data) -> Any! {
        do {
            let data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return data
        } catch let error {
            print(error)
            return nil
        }
    }
}

