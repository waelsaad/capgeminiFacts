//
//  FactWebservice.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import Foundation
import Alamofire

enum Result<T>{
    case response(T)
    case error(error: Error)
}

class FactWebservice {
    typealias T = [Fact]
    
    internal func parseFeed(jsonData: [String : Any]) -> [Fact] {
        var dataArray: [Fact] = []
        for data in jsonData["rows"] as! [[String : Any]] {
            if shouldParseRow(data: data) {
                dataArray.append(Fact(jsonDictionary: data))
            }
        }
        return dataArray
    }
    
    internal func shouldParseRow(data: [String: Any]) -> Bool {
        guard (data["title"] as? String) != nil else {
            return false
        }
        return true
    }
    
    public func getData( completionHandler: @escaping (Result<T>) -> Void) {
        Alamofire.request(WebserviceUrl.FactsURL).responseString(completionHandler: { (response) in
            
            print(response.result.value as Any)
            
            if let error = response.result.error {
                completionHandler(Result.error(error: error))
                return
            }
            
            if let data = response.result.value?.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                var jsonResult:Any
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                }
                catch {
                    completionHandler(Result.error(error: NSError(domain:"JSON Not Proper", code:1101, userInfo:nil)))
                    return
                }
                
                guard let jsonData = jsonResult as? [String: Any] else {
                    completionHandler(Result.error(error: NSError(domain:"JSON Not Proper", code:1101, userInfo:nil)))
                    return
                }

                let feedReceived = self.parseFeed(jsonData: jsonData)
                completionHandler(Result.response(feedReceived))
            }
        })
    }
}
