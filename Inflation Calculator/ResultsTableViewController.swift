//
//  ResultsTableViewController.swift
//  Inflation Calculator
//
//  Created by Marco on 19/05/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    //MARK: UI elements
    @IBOutlet weak var startYearLabel: UILabel!
    @IBOutlet weak var startYearAmount: UILabel!
    @IBOutlet weak var endYearLabel: UILabel!
    @IBOutlet weak var endYearAmount: UILabel!
    @IBOutlet weak var actualValueLabel: UILabel!
    @IBOutlet weak var actualValueAmount: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //MARK: Segue data
    var amount : String?
    var currency : String?
    var start : String?
    var end : String?
    var indice : String?
    var symbol : String?
    
    let NUMBER_OF_SECTIONS = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Results"
        getInflationValue(amount:amount!, curr: currency!, start: start!, end: end!, index:indice!, symbol: symbol!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1) ? 2 : 1
    }

    //MARK: Private functions
    
    private func getInflationValue(amount:String, curr:String, start:String, end:String, index:String, symbol:String) {
        
        startYearLabel.text = start
        endYearLabel.text = end
        actualValueLabel.text = end
        let formattedAmount = amount.currencyInputFormatting(currency: symbol)
        startYearAmount.text = formattedAmount
        
        let amountWithInflation = String(format:"%.2f", conversion.calcInflation(start: start, end: end, currency: curr, amount: amount))
        let formattedAmountWithInflation = amountWithInflation.currencyInputFormatting(currency: symbol)
        endYearAmount.text = formattedAmountWithInflation

        //Conversion to eur
        if curr=="ITL" {
            let liraToEur = String(
                conversion.liraToEur(year: start, amount: amount))
                .currencyInputFormatting(currency: curr)
                .dropFirst(3)
            self.actualValueAmount.text = "€\(liraToEur)"
        } else {
            conversion.toEur(currency: curr, amountWithInflation: amountWithInflation, completionHandler: {
                eur in
                let eurValue = String(format:"%.2f", eur).currencyInputFormatting(currency: "€")
                self.actualValueAmount.text = "\(eurValue)"
                self.detailLabel.text = "\(formattedAmount) in \(start) has the same purchasing power as \(formattedAmountWithInflation) or \(eurValue) in \(end)."
            })
        }
        detailLabel.text = "\(formattedAmount) in \(start) has the same purchasing power as \(formattedAmountWithInflation) in \(end)."
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ChartViewController = (segue.destination as! ChartViewController)
        ChartViewController.start = start
    }
}
