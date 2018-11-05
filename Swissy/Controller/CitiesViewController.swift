//
//  CitiesViewController.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CitiesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupTable(tableView)
        if let viewModel = viewModel {
            tableView.dataSource = viewModel
        }
    }
}
