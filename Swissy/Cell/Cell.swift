//
//  Cell.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

enum Cell: String {
    case cityForecast = "CityForecastCell"
    
    func register(_ tableView: UITableView) {
        tableView.register(UINib(nibName: rawValue, bundle: nil), forCellReuseIdentifier: rawValue)
    }
    
    func dequeue<T: UITableViewCell>(_ tableView: UITableView) -> T? {
        return tableView.dequeueReusableCell(withIdentifier: rawValue) as? T
    }
}
