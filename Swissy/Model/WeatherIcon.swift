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
            return String.fontAwesomeIcon(name: .cloudMoon)
        case .clearDay:
            return String.fontAwesomeIcon(name: .sun)
        case .clearNight:
            return String.fontAwesomeIcon(name: .moon)
        case .partlyCloudyDay:
            return String.fontAwesomeIcon(name: .cloudSun)
        case .cloudy:
            return String.fontAwesomeIcon(name: .cloud)
        default:
            return String.fontAwesomeIcon(name: .surprise)
        }
    }
}
