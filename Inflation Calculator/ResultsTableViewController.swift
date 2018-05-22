//
//  ResultsTableViewController.swift
//  Inflation Calculator
//
//  Created by Marco on 19/05/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit
//import Alamofire

class ResultsTableViewController: UITableViewController {

    //MARK: UI elements
    
    @IBOutlet weak var startYearLabel: UILabel!
    @IBOutlet weak var startYearAmount: UILabel!
    @IBOutlet weak var endYearLabel: UILabel!
    @IBOutlet weak var endYearAmount: UILabel!
    @IBOutlet weak var actualValueLabel: UILabel!
    @IBOutlet weak var actualValueAmount: UILabel!
    
    //MARK: Segue data
    var amount : String?
    var currency : String?
    var start : String?
    var end : String?
    var indice : String?
    var symbol : String?
    
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
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        } else {
            return 1
        }
    }

    //MARK: Private functions
    
    private func getInflationValue(amount:String, curr:String, start:String, end:String, index:String, symbol:String) {
        
        startYearLabel.text = start
        endYearLabel.text = end
        actualValueLabel.text = end
        startYearAmount.text = amount.currencyInputFormatting(currency: symbol)
        
        let amountWithInflation = String(format:"%.2f", conversion.calcInflation(start: start, end: end, currency: curr, amount: amount))
        endYearAmount.text = amountWithInflation.currencyInputFormatting(currency: symbol)
        //print(amountWithInflation)
        if curr=="ITL" {
            let liraToEur = String(
                conversion.liraToEur(year: start, amount: amount))
                .currencyInputFormatting(currency: curr)
                .dropFirst(3)
            self.actualValueAmount.text = "€\(liraToEur)"
        } else {
            conversion.toEur(currency: curr, amountWithInflation: amountWithInflation, completionHandler: {
                eur in
                let eurValue = String(eur).currencyInputFormatting(currency: "€")
                self.actualValueAmount.text = "\(eurValue)"
            })
        }
    }
    
//    private func getInflationValueNet(amount:String, curr:String, start:String, end:String, index:String, symbol:String) {
//
//        //loading alert
////        let loadingAlert = UIAlertController(title: nil, message: "Calculating inflation...", preferredStyle: .alert)
////        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
////        loadingIndicator.hidesWhenStopped = true
////        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
////        loadingIndicator.startAnimating();
////        loadingAlert.view.addSubview(loadingIndicator)
////        present(loadingAlert, animated: true, completion: nil)
//
//        let url = "http://fxtop.com/en/inflation-calculator.php?A=\(amount)&C1=\(curr)&INDICE=\(index)&DD1=01&MM1=01&YYYY1=\(start)&DD2=01&MM2=01&YYYY2=\(end)&btnOK=Compute+actual+value"
//
//        print(url)
//
//        self.startYearLabel.text = start
//        self.endYearLabel.text = end
//        self.actualValueLabel.text = end
//
//        Alamofire.request(url).responseString { response in
//            if let html = response.result.value {
//                let res = self.parseHTML(html: html)
//
////                loadingAlert.dismiss(animated: true, completion: nil)
//
//                if res[1]=="" {
//                    let alert = UIAlertController(title: "Error", message: "No results.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//                } else {
//
//                let inflazioneNum = res[1].split(separator: ":")[1].replacingOccurrences(of: " ", with: "", options: .regularExpression)
//
//                self.startYearAmount.text = "\(amount.currencyInputFormatting(currency: symbol))"
//                self.endYearAmount.text = "\(res[0].currencyInputFormatting(currency: symbol))"
////                self.inflationAmount.text = "+\(inflazioneNum)"
////                self.graphImageView.downloadedFrom(link: "http://fxtop.com/php/imggraph.php?C1=\(curr)i&C2=\(curr)&A=1&DD1=01&MM1=01&YYYY1=\(start)&DD2=01&MM2=01&YYYY2=\(end)&LANG=en&CJ=0&VAR=1Y&LARGE=")
//
//
//                if curr=="ITL" {
//                    let liraToEur = String(
//                        conversion.calcInflation(start: start, end: end, currency: curr, amount: res[0]))
//                        .currencyInputFormatting(currency: symbol)
//                        .dropFirst(1)
//                    self.actualValueAmount.text = "€\(liraToEur)"
//                } else {
//                    conversion.toEur(currency: curr, amountWithInflation:res[0], completionHandler: {
//                        eur in
//                        let eurValue = String(eur).currencyInputFormatting(currency: "€")
//                        self.actualValueAmount.text = "\(eurValue)"
//                    })
//                }
//            }
//            }
//        }
//
//    }
//
//    private func parseHTML(html: String) -> [String] {
//        var returnValue = [String]()
//        do {
//            //prezzo
//            let regex = try NSRegularExpression(pattern: "(?<=The equivalent of)(.*)(?=used)")
//            let results = regex.matches(in: html, range: NSRange(html.startIndex..., in: html))
//            if results == [] {
//                return ["Nessun risultato", ""]
//            }
//            else {
//                //Ottengo prezzi e inflazione
//                let res = results.map {
//                    String(html[Range($0.range, in: html)!])
//                    }[0]
//                    .replacingOccurrences(of: "\\<.*?\\>", with: "", options: .regularExpression)
//                    .replacingOccurrences(of: "\\(.*?\\)", with: "", options: .regularExpression)
//                    .components(separatedBy: "Inflation")
//
//                let inflation = res[1].dropLast(2)
//                //Prendo solo il prezzo attuale
//                let amount =
//                    try NSRegularExpression(pattern: "(?<=is)(.*)(?=on)")
//                        .matches(in: res[0], range: NSRange(res[0].startIndex..., in: res[0]))
//                        .map {
//                            String(res[0][Range($0.range, in: res[0])!])
//                        }[0]
//                        .dropLast(4)
//
//                returnValue = [String(amount),String(inflation)]
//            }
//        } catch let error {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    return returnValue
//    }

}
