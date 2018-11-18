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
    
    private var reload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemAdd.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .white, size: CGSize(width: 26, height: 26))
        
        viewModel?.setupTable(tableView)
        bindModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if reload {
            reload = false
            viewModel?.startReload()
        }
    }
    
    @objc func applicationDidBecomeActive() {
        guard navigationController?.visibleViewController == self else {
            reload = true
            return
        }
        
        viewModel?.startReload()
    }
    
    @IBAction func addClicked(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ForecastViewController {
            let viewModel = ForecastViewModel()
            
            if let city = self.viewModel?.showCityForecast.value, let id = city.id {
                viewModel.dailyForecast = self.viewModel?.forecasts[id]?.daily?.data
                viewModel.city = city
            }
            
            viewController.viewModel = viewModel
        }
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
        
        viewModel?.showCityForecast.bind { [weak self] city in
            if let _ = city {
                self?.performSegue(withIdentifier: "cityForecast", sender: nil)
            }
        }
    }
}
