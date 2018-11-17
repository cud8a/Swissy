//
//  AnimatedDotsViewController.swift
//  Swissy
//
//  Created by Tamas Bara on 17.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class AnimatedDotsViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet var dots: [UIView]!
    @IBOutlet weak var dotsContainer: UIView!
    
    var showDimView = false
    
    init(showDimView: Bool = false) {
        self.showDimView = showDimView
        super.init(nibName: "AnimatedDotsViewController", bundle: nil)
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
        animateDots()
    }
    
    private func _fadeIn() {
        UIView.animate(withDuration: 0.3) {
            if self.showDimView {
                self.dimView.alpha = 0.7
            }
            self.dotsContainer.alpha = 1
        }
    }
    
    private func _fadeOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.showDimView {
                self.dimView.alpha = 0
            }
            self.dotsContainer.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dots.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func animateDots() {
        for (index, dot) in dots.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0.1 * Double(index), options: [.repeat, .autoreverse], animations: {
                dot.alpha = 1
            }, completion: nil)
        }
    }
    
    func hide() {
        _fadeOut {
            self.removeFromParent()
        }
    }
    
    deinit {
        print("--- AnimatedDotsViewController - deinit")
    }
}
