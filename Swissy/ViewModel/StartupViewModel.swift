//
//  StartupViewModel.swift
//  Swissy
//
//  Created by Tamas Bara on 03.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class StartupViewModel: NSObject {
    
    let state: Dynamic<ViewModelState> = Dynamic(.initial)
    let segue: Dynamic<String?> = Dynamic(nil)
    var forecasts: [String: ForecastResponse] = [:]
    var cities: [City]?
    
    override init() {
        super.init()
        loadCities()
    }
    
    private func loadCities() {
        state.value = .loading
        CitiesService.cities { [weak self] cities, error in
            if let _ = error {
                self?.state.value = .error
            } else {
                self?.cities = cities
                self?.loadForecasts()
            }
        }
    }
    
    private func loadForecasts() {
        getForecast(withIndex: 0)
    }
    
    private func getForecast(withIndex index: Int) {
        
        guard let city = cities?[safe: index] else {
            state.value = .success
            segue.value = Segue.cities.rawValue
            return
        }
        
        ForecastService.forecast(withCity: city) { [weak self] forecast, error in
            if let id = city.id, let forecast = forecast {
                self?.forecasts[id] = forecast
                self?.getForecast(withIndex: index + 1)
            } else {
                self?.state.value = .error
            }
        }
    }
}


