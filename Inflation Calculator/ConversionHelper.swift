//
//  ConversionHelper.swift
//  Inflation Calculator
//
//  Created by Marco on 20/05/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct conversion {
    
    static func calcInflation(start:String, end:String, currency:String, amount:String) -> Double{

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "it_IT")
        let formattedAmount = numberFormatter.number(from: amount) as! Double?
        
        var table = [String:Double]()
        switch currency {
        case "USD":
            table = conversionTables.dollarConversionTable
        case "GBP":
            table = conversionTables.poundConversionTable
        case "ITL":
            table = conversionTables.liraConversionTable
            return formattedAmount! * table[start]!
        default:
            print("Currency not recognized")
        }
        
        let new_CPI = table[end]!
        let old_CPI = table[start]!
        return (formattedAmount! * (new_CPI / old_CPI)).rounded(toPlaces: 2)
    }
    
    static func liraToEur(year:String, amount:String) -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "it_IT")
        let formattedAmount = numberFormatter.number(from: amount) as! Double?
        let coeff = conversionTables.liraConversionTableToEur[year]!
        return (formattedAmount! * (coeff / 1936.27)).rounded(toPlaces: 2)
    }
    
    static func toEur(currency:String, amountWithInflation:String, completionHandler: @escaping ((Double) -> Void)) {
        let amount = Double(amountWithInflation.trim())
        let url = "http://free.currencyconverterapi.com/api/v5/convert?q=\(currency)_EUR&compact=y"
        var eur = 0.0
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                let fattore = (JSON(json)["\(currency)_EUR"]["val"]).double
                eur = Double((amount! * fattore!).rounded(toPlaces: 2))
                completionHandler(eur)
            }
        }
    }
    
}
