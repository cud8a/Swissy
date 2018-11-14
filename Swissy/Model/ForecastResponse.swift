//
//  ForecastResponse.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import ObjectMapper

struct ForecastResponse {
    var currently: WeatherInfo?
    var daily: Forecast?
}

extension ForecastResponse: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        currently <- map["currently"]
        daily <- map["daily"]
    }
}
