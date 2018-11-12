//
//  ForecastService.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import Alamofire
import ObjectMapper

enum ForecastService {
    
    static let url = "https://api.darksky.net/forecast/df43b82dc1629a1d06f62acc4597aa31/$LAT,$LONG?exclude=hourly,flags&lang=de&units=si"
    
    static func forecast(withCity city: City, completion: @escaping (ForecastResponse?, Error?) -> Void) {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.minimumIntegerDigits = 1
        formatter.decimalSeparator = "."
        
        guard let lat = city.latitude, let latitude = formatter.string(for: lat),
            let long = city.longitude, let longitude = formatter.string(for: long) else {
            completion(nil, ServiceError(message: "missing arguments"))
            return
        }
        
        let url = ForecastService.url.replacingOccurrences(of: "$LAT", with: latitude).replacingOccurrences(of: "$LONG", with: longitude)
        
        if let url = URL(string: url) {
            let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: nil).validate().responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let forecastResponse = Mapper<ForecastResponse>().map(JSONObject: JSON)
                    completion(forecastResponse, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
            
            debugPrint(request)
        }
    }
}
