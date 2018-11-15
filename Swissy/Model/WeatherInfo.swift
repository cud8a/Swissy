//
//  WeatherInfo.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import ObjectMapper

struct WeatherInfo {
    
    let celsiusformatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumIntegerDigits = 1
        return formatter
    } ()
    
    var info: String? {
        var info = temperatureCelsius ?? ""
        if let summary = summary {
            if info.isEmpty == false {
                info += ", "
            }
            
            info += summary
        }
        
        return info
    }
    
    var minMax: String? {
        if let min = temperatureMinCelsius, let max = temperatureMaxCelsius {
            return min + "/" + max
        }
        
        return nil
    }
    
    var temperatureCelsius: String? {
        if let temp = celsiusformatter.string(for: temperature) {
            return temp + "°C"
        }

        return nil
    }
    
    var temperatureMinCelsius: String? {
        if let temp = celsiusformatter.string(for: temperatureMin) {
            return temp + "°C"
        }

        return nil
    }
    
    var temperatureMaxCelsius: String? {
        if let temp = celsiusformatter.string(for: temperatureMax) {
            return temp + "°C"
        }

        return nil
    }
    
    var dayShort: String? {
        if let time = time {
            let formatter = DateFormatter(withFormat: "E", locale: "DE")
            formatter.shortWeekdaySymbols = ["S", "M", "D", "M", "D", "F", "S"]
            return formatter.string(from: time)
        }
        
        return nil
    }

    var summary: String?
    var icon: WeatherIcon?
    var temperature: Double?
    var temperatureMin: Double?
    var temperatureMax: Double?
    var time: Date?
}

extension WeatherInfo: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        summary <- map["summary"]
        icon <- map["icon"]
        temperature <- map["temperature"]
        temperatureMin <- map["temperatureMin"]
        temperatureMax <- map["temperatureMax"]
        time <- (map["time"], DateTransform())
    }
}

