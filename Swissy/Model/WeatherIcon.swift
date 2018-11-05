//
//  WeatherIcon.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import Foundation

enum WeatherIcon: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    
    var image: String {
        switch self {
        case .partlyCloudyNight:
            return ""
        case .clearDay:
            return ""
        case .clearNight:
            return ""
        case .rain:
            return ""
        case .cloudy:
            return ""
        default:
            return ""
        }
    }
}
