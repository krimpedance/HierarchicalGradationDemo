//
//  ViewController.swift
//  HierarchicalGradationDemo
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var hierarchicalGradientView: UITableView!
    
    var colors :[UIColor] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // gradient colors
        let startColor = UIColor.redColor()
        let endColor = UIColor.yellowColor()
        
        // create gradient
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView.bounds
        gradient.colors = [
            startColor.CGColor,
            endColor.CGColor
        ]
        self.gradientView.layer.addSublayer(gradient)
        
        
        // pick color
        let divisionCount = 7
        let interval = self.gradientView.frame.height / CGFloat(divisionCount)
        self.colors = (0..<divisionCount).map {
            let index = CGFloat($0)
            let point = CGPointMake(0, index*interval)
            return self.colorOfPoint(gradient, point: point)
        }
        self.hierarchicalGradientView.reloadData()
    }
    
    private func colorOfPoint(gradation :CAGradientLayer, point:CGPoint)->UIColor {
        var pixel:[CUnsignedChar] = [0,0,0,0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmap.rawValue)
        
        CGContextTranslateCTM(context, -point.x, -point.y)
        gradation.renderInContext(context!)
        
        let red:CGFloat = CGFloat(pixel[0])/255.0
        let green:CGFloat = CGFloat(pixel[1])/255.0
        let blue:CGFloat = CGFloat(pixel[2])/255.0
        let alpha:CGFloat = CGFloat(pixel[3])/255.0
        
        return UIColor(red:red, green: green, blue:blue, alpha:alpha)
    }

}


extension ViewController :UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.gradientView.frame.height / CGFloat(self.colors.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") ?? UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        cell.backgroundColor = self.colors[indexPath.row]
        
        return cell
    }
}