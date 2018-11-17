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
    
    let viewModel = StartupViewModel()
    let points = AnimatedPointsViewController()
    
    var canContinueFromUI = false {
        didSet {
            canContinueFromUI = true
            _continue()
        }
    }
    
    var canContinueFromViewModel = false {
        didSet {
            canContinueFromViewModel = true
            _continue()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(points)
        delay(closure: { self.animateSwissy() }, after: .milliseconds(10))
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
        viewModel.segue.bind { [weak self] segue in
            if let _ = segue {
                self?.canContinueFromViewModel = true
            }
        }
    }
    
    private func animateSwissy() {
        topSpace?.isActive = false
        labelSwissy.centerYToSuperview(offset: -60)
        UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        
        delay(closure: { self.canContinueFromUI = true }, after: .seconds(2))
    }
    
    private func _continue() {
        guard canContinueFromUI, canContinueFromViewModel else {return}
        points.hide()
        
        UIView.animate(withDuration: 0.3) {
            self.labelSwissy.alpha = 0
        }
        
        if let segue = self.viewModel.segue.value {
            self.performSegue(withIdentifier: segue, sender: nil)
        }
    }
}
