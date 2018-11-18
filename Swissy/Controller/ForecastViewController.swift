//
//  ForecastViewController.swift
//  Swissy
//
//  Created by Tamas Bara on 17.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupTable(tableView)
        title = viewModel?.city?.name
    }
}
