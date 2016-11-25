//
//  CalligraphyView.swift
//  ChineseCalligraphy
//
//  Created by Dong, Yiming (Agoda) on 11/24/2559 BE.
//  Copyright © 2559 Dong, Yiming (Agoda). All rights reserved.
//

import UIKit

class StrokeLine {
    var dots = [CGPoint]()
    
    func addDot(dot: CGPoint) {
        dots.append(dot)
    }
    
    func belongingPathFrom(paths: [UIBezierPath]) -> UIBezierPath? {
        
        var belongingPath: UIBezierPath? = nil
        
        var maxNumberOfDots: Int = 0
        paths.forEach { (path) in
            var numberOfDots = 0
            dots.forEach({ (dot) in
                if path.contains(dot) {
                    numberOfDots += 1
                }
            })
            
            if numberOfDots > maxNumberOfDots {
                belongingPath = path
                maxNumberOfDots = numberOfDots
            }
        }
        
        return belongingPath
    }
}

class CalligraphyView: UIView {
    
//    var lines = [UIBezierPath]()
//    var currentLine: UIBezierPath?
    
    var dotLines = [StrokeLine]()
    var currentDotLine: StrokeLine?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
//        doubleTap.cancelsTouchesInView = false
        addGestureRecognizer(doubleTap)
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
        
        Nine.drawCanvas1(frame: rect2)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            
            let paths = Nine.shape(frame: rect2)
            
            dotLines.forEach({ (strokeLine) in
                
                context.saveGState()
                
                if let belongingPath = strokeLine.belongingPathFrom(paths: paths) {
                    belongingPath.addClip()
                }
                
                strokeLine.dots.forEach({ (point) in
                    UIColor.black.withAlphaComponent(0.1).setFill()
                    let outterPath = UIBezierPath(arcCenter: point, radius: 30, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
                    outterPath.fill()
                    
                    UIColor.black.withAlphaComponent(0.3).setFill()
                    let centerPath = UIBezierPath(arcCenter: point, radius: 20, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
                    centerPath.fill()
                    
                    UIColor.black.setFill()
                    let dotPath = UIBezierPath(arcCenter: point, radius: 15, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
                    dotPath.fill()
                })
                
                context.restoreGState()
            })
            
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image?.draw(in: rect)
    }

    func doubleTapAction(gesture: UITapGestureRecognizer) {
        
        dotLines.removeAll()
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        currentDotLine = StrokeLine()
        dotLines.append(currentDotLine!)
        currentDotLine?.addDot(dot: location)
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        currentDotLine?.addDot(dot: location)
        
        setNeedsDisplay()
    }
}
