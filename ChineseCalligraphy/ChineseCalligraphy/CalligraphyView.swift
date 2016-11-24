//
//  CalligraphyView.swift
//  ChineseCalligraphy
//
//  Created by Dong, Yiming (Agoda) on 11/24/2559 BE.
//  Copyright © 2559 Dong, Yiming (Agoda). All rights reserved.
//

import UIKit

class CalligraphyView: UIView {
    
    var lines = [UIBezierPath]()
    var dragStartPoint: CGPoint?
    var currentLine: UIBezierPath?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(drag))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        
        let rect1 = rect.insetBy(dx: rect.width * 0.25, dy: 20)
        let rect2 = rect.insetBy(dx: 20, dy: rect.height * 0.25)
        
        let path1 = UIBezierPath(rect: rect)
        UIColor.yellow.setFill()
        path1.fill()
        
        StarDot.drawCanvas1(frame: rect2)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            
            StarDot.shape(frame: rect2).addClip()
            lines.forEach { (line) in
                
                UIColor.black.setStroke()
                line.lineWidth = 20
                line.stroke()
            }
            
            context.restoreGState()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image?.draw(in: rect)
        
        print("redrawed!!!!")
    }

    func drag(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            currentLine = UIBezierPath()
            lines.append(currentLine!)
            currentLine?.lineCapStyle = .round
            currentLine?.move(to: location)
        case .changed:
            currentLine?.addLine(to: location)
        case .ended, .cancelled:
            currentLine = nil
            dragStartPoint = nil
        default: break
        }
        
        setNeedsDisplay()
    }
}
