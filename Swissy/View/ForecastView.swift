//
//  ForecastView.swift
//  Swissy
//
//  Created by Tamas Bara on 14.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import UIKit

class ForecastView: UIView {

    var forecast: [CGFloat]?
    var days: [String]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let attributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8),
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    override func draw(_ rect: CGRect) {
    
        guard let forecast = forecast else {return}
        
        let minimum = forecast.min() ?? 0
        
        let threshold = UIBezierPath()
        
        let yThreshold = rect.height - 56 + minimum / 2
        threshold.move(to: CGPoint(x: 4, y: yThreshold))
        threshold.addLine(to: CGPoint(x: rect.width - 8, y: yThreshold))
        
        UIColor.lightGray.set()
        threshold.lineWidth = 0.5
        threshold.stroke()
        
        let lines = UIBezierPath()
        
        for (index, temperature) in forecast.enumerated() {
            
            if index > 6 {
                break
            }
            
            let x = CGFloat(10 + index * 12)
            let y = CGFloat(rect.height - 40 - temperature + minimum / 2)
            let drect = CGRect(x: x, y: y, width: 5, height: 5)
            let bpath = UIBezierPath(roundedRect: drect, cornerRadius: 2)
            UIColor.white.set()
            bpath.fill()
            
            if index == 0 {
                lines.move(to: CGPoint(x: x + 2.5, y: y + 2.5))
            } else {
                lines.addLine(to: CGPoint(x: x + 2.5, y: y + 2.5))
            }
            
            if let day = days?[safe: index] {
                let attributedString = NSAttributedString(string: day, attributes: attributes)
                
                let stringRect = CGRect(x: x, y: rect.height - 30, width: 10, height: 10)
                attributedString.draw(in: stringRect)
            }
        }
        
        UIColor.white.set()
        lines.stroke()
    }
}
