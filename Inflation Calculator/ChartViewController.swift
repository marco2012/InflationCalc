//
//  ChartViewController.swift
//  Inflation Calculator
//
//  Created by Marco on 22/05/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit
import SwiftChart

class ChartViewController: UIViewController, ChartDelegate {
    

    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var chart: Chart!
    
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    
    var start : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant

        initializeChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeChart() {
        chart.delegate = self
        
        // Initialize data series and labels
        let stockValues = getStockValues()
        
        var serieData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: Array<String> = []
        
        // Date formatter to retrieve the month names
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        
        for (i, value) in stockValues.enumerated() {
            
            serieData.append(value["close"] as! Double)
            
            // Use only one label for each month
            let yearAsString = value["date"] as! String
            if (labels.count == 0 || labelsAsString.last != yearAsString) {
                labels.append(Double(i))
                labelsAsString.append(yearAsString)
            }
        }
        
        labels.sort()
        labelsAsString.sort()
        
        let series = ChartSeries(serieData)
        series.area = true
        
        // Configure chart layout
        
        chart.lineWidth = 1.0
        chart.labelFont = UIFont.systemFont(ofSize: 14)
        chart.xLabels = labels
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        chart.xLabelsTextAlignment = .center
//        chart.yLabelsOnRightSide = true
        
        // Add some padding above the x-axis
//        chart.minY = serieData.min()! - 0.5
//        chart.maxY = serieData.max()! + 0.5
        
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1)) + "%" }
        
        chart.add(series)
    }
    
    // Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.minimumIntegerDigits = 1
            label.text = numberFormatter.string(from: NSNumber(value: value))
            
            // Align the label to the touch left position, centered
            var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)
            
            // Avoid placing the label on the left of the chart
            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }
            
            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - label.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }
            
            labelLeadingMarginConstraint.constant = constant
            
        }
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    
    func getStockValues() -> Array<Dictionary<String, Any>> {
        var values = Array<Dictionary<String, Any>>()
        for (anno, valore) in conversionTables.dollarConversionTable {
            let s = Int(start!)!
            let a = Int(anno)!
            
            if a >= s {
                
                if s < 1900 && a % 25 == 0 {
                    values.append(["date": anno, "close": valore])
                } else if s >= 1900 && a % 15 == 0 {
                    values.append(["date": anno, "close": valore])
                } else if s >= 1950 && a % 5 == 0 {
                    values.append(["date": anno, "close": valore])
                }
            }
            
        }
        return values
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }

}
