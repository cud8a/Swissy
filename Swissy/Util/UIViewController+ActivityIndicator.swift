//
//  UIViewController+ActivityIndicator.swift
//  Swissy
//
//  Created by Tamas Bara on 17.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoading() {
        (parent ?? self)._showLoading()
    }
    
    private func _showLoading() {
        guard children.filter({$0 is AnimatedDotsViewController}).count == 0 else {return}
        
        let dots = AnimatedDotsViewController(showDimView: true)
        addChild(dots)
        
        MinimumShow.start(viewController: self)
    }
    
    func hideLoading() {
        (parent ?? self)._hideLoading()
    }
    
    private func _hideLoading() {
        MinimumShow.hide(viewController: self)
    }
    
    private func _hide() {
        guard let dots = children.filter({$0 is AnimatedDotsViewController}).first as? AnimatedDotsViewController else {return}
        dots.hide()
    }
    
    private enum MinimumShow {
    
        private static var canHideFromUI = true
        private static var canHideFromController = true
        
        static func start(viewController: UIViewController) {
            self.canHideFromUI = false
            self.canHideFromController = false
            delay(closure: { MinimumShow.hideFromUI(viewController: viewController) }, after: .seconds(2))
        }
        
        private static func hideFromUI(viewController: UIViewController) {
            self.canHideFromUI = true
            if self.canHideFromController {
                viewController._hide()
            }
        }
        
        static func hide(viewController: UIViewController) {
            self.canHideFromController = true
            if self.canHideFromUI {
                viewController._hide()
            }
        }
    }
}
