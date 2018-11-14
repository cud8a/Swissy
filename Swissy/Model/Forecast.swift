//
//  Forecast.swift
//  Swissy
//
//  Created by Tamas Bara on 14.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import ObjectMapper

struct Forecast {
    var data: [WeatherInfo]?
}

extension Forecast: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}
