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
    
    override func draw(_ rect: CGRect) {
    
        guard let forecast = forecast else {return}
        
        UIColor.white.set()
        let lines = UIBezierPath()
        
        for (index, temperature) in forecast.enumerated() {
            
            if index > 6 {
                break
            }
            
            let x = CGFloat(10 + index * 12)
            let y = CGFloat(rect.height - 10 - temperature)
            let drect = CGRect(x: x, y: y, width: 5, height: 5)
            let bpath = UIBezierPath(roundedRect: drect, cornerRadius: 2)
            bpath.fill()
            
            if index == 0 {
                lines.move(to: CGPoint(x: x + 2.5, y: y + 2.5))
            } else {
                lines.addLine(to: CGPoint(x: x + 2.5, y: y + 2.5))
            }
        }
        
        lines.stroke()
        
        let threshold = UIBezierPath()
        threshold.move(to: CGPoint(x: 4, y: rect.height - 26))
        threshold.addLine(to: CGPoint(x: rect.width - 8, y: rect.height - 26))
        
        UIColor.lightGray.set()
        threshold.lineWidth = 0.5
        threshold.stroke()
    }
}
