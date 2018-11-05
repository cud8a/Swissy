//
//  StartupViewController.swift
//  Swissy
//
//  Created by Tamas Bara on 03.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit
import Alamofire
import TinyConstraints

class StartupViewController: UIViewController {

    @IBOutlet weak var labelSwissy: UILabel!
    @IBOutlet weak var topSpace: NSLayoutConstraint?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = StartupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSwissy()
        bindModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navi = segue.destination as? UINavigationController, let vc = navi.topViewController as? CitiesViewController {
            let viewModel = CitiesViewModel()
            viewModel.forecasts = self.viewModel.forecasts
            viewModel.cities = self.viewModel.cities
            vc.viewModel = viewModel
        }
    }
    
    private func bindModel() {
        viewModel.state.bind { [weak self] state in
            switch state {
            case .loading: self?.activityIndicator.startAnimating()
            default: self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.segue.bind { [weak self] segue in
            if let segue = segue {
                self?.performSegue(withIdentifier: segue, sender: nil)
            }
        }
    }
    
    private func animateSwissy() {
        topSpace?.isActive = false
        activityIndicator?.topToBottom(of: labelSwissy, offset: 10)
        UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
}
