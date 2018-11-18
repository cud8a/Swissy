//
//  ForecastViewModel.swift
//  Swissy
//
//  Created by Tamas Bara on 17.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class ForecastViewModel: NSObject {
    
    var city: City?
    var dailyForecast: [WeatherInfo]?
    
    func setupTable(_ tableView: UITableView) {
        Cell.dailyForecast.register(tableView)
        tableView.dataSource = self
    }
}

extension ForecastViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: DailyForecastCell = Cell.dailyForecast.dequeue(tableView), let weatherInfo = dailyForecast?[safe: indexPath.row] {
            cell.labelDay.text = weatherInfo.dayLong
            cell.labelIcon.text = weatherInfo.icon?.image
            cell.labelInfo.text = weatherInfo.summary
            cell.labelMinMax.text = weatherInfo.minMax
            cell.labelSunrise.text = weatherInfo.sunrise
            cell.labelSunset.text = weatherInfo.sunset
            return cell
        }
        return UITableViewCell()
    }
}
