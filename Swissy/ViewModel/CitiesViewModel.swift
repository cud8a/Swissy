//
//  CitiesViewModel.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class CitiesViewModel: NSObject {
 
    var forecasts: [String: ForecastResponse] = [:]
    var cities: [City]?
    
    func setupTable(_ tableView: UITableView) {
        Cell.cityForecast.register(tableView)
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
            }
            return cell
        }
        return UITableViewCell()
    }
}
