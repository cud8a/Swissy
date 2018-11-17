//
//  AnimatedPointsViewController.swift
//  Swissy
//
//  Created by Tamas Bara on 17.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class AnimatedPointsViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet var points: [UIView]!
    @IBOutlet weak var pointsContainer: UIView!
    
    var showDimView = false
    
    init(showDimView: Bool = false) {
        self.showDimView = showDimView
        super.init(nibName: "AnimatedPointsViewController", bundle: nil)
        addObserver(self, forKeyPath: #keyPath(parent), options: [.old, .new], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = parent else {
            view.removeFromSuperview()
            return
        }
        
        parent?.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.edgesToSuperview()
        _fadeIn()
        animatePoints()
    }
    
    private func _fadeIn() {
        UIView.animate(withDuration: 0.3) {
            if self.showDimView {
                self.dimView.alpha = 0.7
            }
            self.pointsContainer.alpha = 1
        }
    }
    
    private func _fadeOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.showDimView {
                self.dimView.alpha = 0
            }
            self.pointsContainer.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        points.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func animatePoints() {
        for (index, point) in points.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0.1 * Double(index), options: [.repeat, .autoreverse], animations: {
                point.alpha = 1
            }, completion: nil)
        }
    }
    
    func hide() {
        _fadeOut {
            self.removeFromParent()
        }
    }
    
    deinit {
        print("--- AnimatedPointsViewController - deinit")
    }
}
