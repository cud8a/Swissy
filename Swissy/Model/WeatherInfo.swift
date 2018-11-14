//
//  WeatherInfo.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import ObjectMapper

struct WeatherInfo {
    
    var info: String? {
        var info = temperature ?? ""
        if let summary = summary {
            if info.isEmpty == false {
                info += ", "
            }
            
            info += summary
        }
        
        return info
    }
    
    var summary: String?
    var icon: WeatherIcon?
    var temperature: String?
    var temperatureMax: Int?
}

class TemperatureTransform: TransformType {
  
    func transformFromJSON(_ value: Any?) -> String? {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        if let str = formatter.string(for: value) {
            return str + "°C"
        }
        
        return nil
    }
    
    func transformToJSON(_ value: String?) -> Double? {
        if let number = value?.dropLast(2) {
            return Double(number)
        }
        
        return nil
    }
}

class TemperatureMaxTransform: TransformType {
    
    func transformFromJSON(_ value: Any?) -> Int? {
        if let d = value as? Double {
            return Int(d)
        }
        
        return nil
    }
    
    func transformToJSON(_ value: Int?) -> Double? {
        if let i = value {
            return Double(i)
        }
        
        return nil
    }
}

extension WeatherInfo: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        summary <- map["summary"]
        icon <- map["icon"]
        temperature <- (map["temperature"], TemperatureTransform())
        temperatureMax <- (map["temperatureMax"], TemperatureMaxTransform())
    }
}

