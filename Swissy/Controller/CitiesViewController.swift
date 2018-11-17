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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemAdd.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .white, size: CGSize(width: 26, height: 26))
        
        viewModel?.setupTable(tableView)
        if let viewModel = viewModel {
            tableView.dataSource = viewModel
        }
        
        bindModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        viewModel?.startReload()
    }
    
    @IBAction func addClicked(_ sender: Any) {
    }
    
    private func bindModel() {
        viewModel?.reload.bind { [weak self] state in
            main {
                switch state {
                case .loading: self?.showLoading()
                default:
                    self?.tableView?.reloadData()
                    self?.hideLoading()
                }
            }
            
        }
    }
}
