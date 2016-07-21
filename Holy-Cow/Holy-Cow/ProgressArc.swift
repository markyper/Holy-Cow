//
//  ProgressArc.swift
//  Holy-Cow
//
//  Created by Marky Pertsemlides on 7/21/16.
//  Copyright © 2016 Holy-Cow iOS Team. All rights reserved.
//

import UIKit

@IBDesignable class ProgressArc: UIView {
    
    @IBInspectable var progressValue: Double = 0 {
        didSet {
            progressValue = min(max(progressValue, 0), 1)
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let π = 3.141592653589793238462643383279502884197169399
        let start = 0.5 * π
        let end = 2.5 * π
        
        progressValue = 0.5 //temporarily
        let progress = progressValue // temporarily
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let thickness = bounds.width/8 // check this later
        let radius = bounds.width/2 - thickness/2
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
        
        UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).setStroke()
        path.lineWidth = thickness
        path.stroke()
        
        
        let arc = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(start), endAngle: CGFloat(progress), clockwise: true)
        UIColor.holyBlue.setStroke()
        arc.lineWidth = thickness
        arc.stroke()
        
    }
    
//    func setProgressValue(value: Double) {
//        
//    }

}