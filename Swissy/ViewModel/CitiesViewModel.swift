//
//  CitiesViewModel.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class CitiesViewModel: NSObject {
 
    let reload: Dynamic<ViewModelState> = Dynamic(.initial)
    
    var forecasts: [String: ForecastResponse] = [:]
    var cities: [City]?
    
    func setupTable(_ tableView: UITableView) {
        Cell.cityForecast.register(tableView)
    }
    
    func startReload() {
        reload.value = .loading
        getForecast(withIndex: 0)
    }
    
    fileprivate func getForecast(withIndex index: Int) {
        
        guard let city = cities?[safe: index] else {
            reload.value = .success
            return
        }
        
        ForecastService.forecast(withCity: city) { [weak self] forecast, error in
            if let id = city.id, let forecast = forecast {
                self?.forecasts[id] = forecast
                self?.getForecast(withIndex: index + 1)
            } else {
                self?.reload.value = .error
            }
        }
    }
}

extension CitiesViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CityForecastCell = Cell.cityForecast.dequeue(tableView), let city = cities?[safe: indexPath.row] {
            cell.labelCity.text = city.name
            if let id = city.id, let currently = forecasts[id]?.currently {
                cell.labelInfo.text = currently.info
                cell.labelIcon.text = currently.icon?.image
                cell.forecast.forecast = forecasts[id]?.daily?.data?.map({CGFloat(2 * ($0.temperatureMax ?? 0))})
                cell.forecast.days = forecasts[id]?.daily?.data?.compactMap({$0.dayShort})
                cell.labelMinMax.text = forecasts[id]?.daily?.data?.first?.minMax
            }
            return cell
        }
        return UITableViewCell()
    }
}
