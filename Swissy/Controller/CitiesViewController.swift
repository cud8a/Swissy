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
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    var viewModel: CitiesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemAdd.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .white, size: CGSize(width: 26, height: 26))
        
        viewModel?.setupTable(tableView)
        if let viewModel = viewModel {
            tableView.dataSource = viewModel
        }
    }
}
