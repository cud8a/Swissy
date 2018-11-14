//
//  CitiesViewController.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit
import Alamofire

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    var viewModel: CitiesViewModel?
    var pull: PullToRefresh?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemAdd.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .white, size: CGSize(width: 26, height: 26))
        
        viewModel?.setupTable(tableView)
        if let viewModel = viewModel {
            tableView.dataSource = viewModel
        }
        
        pull = PullToRefresh(tableView: tableView)
        pull?.delegate = self
        
        bindModel()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        pull?.reloadTable()
    }
    
    private func bindModel() {
        viewModel?.reload.bind { [weak self] state in
            self?.pull?.reloadTable()
        }
    }
}

extension CitiesViewController: PullToRefreshDelegate {
    func refresh() {
        UIImpactFeedbackGenerator().impactOccurred()
        viewModel?.startReload()
    }
}
