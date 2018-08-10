//
//  MainTableViewController.swift
//  Inflation Calculator
//
//  Created by Marco on 19/05/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //MARK: UI elements
    @IBOutlet weak var amountTextField: UITextField!
//    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var startDatePicker: UIPickerView!
    @IBOutlet weak var endDatePicker: UIPickerView!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    
    //MARK: Data sources
//    let currencyPickerData  = ["USD", "GBP", "ITL"]
    var startPickerData     = [Int](1774...2018)
    var endPickerData       = Array([Int](1774...2018).reversed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide keyboard on tap
        self.hideKeyboardWhenTappedAround()
        
        //Add data to currency picker
//        currencyPicker.delegate     = self
        startDatePicker.delegate    = self
        endDatePicker.delegate      = self
        
        //Add listener to amount text field
        amountTextField.addTarget(self, action: #selector(amountTextFieldDidChange), for: .editingChanged)
        
        //start around 1900
        startDatePicker.selectRow(126, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Listeners
    @objc func amountTextFieldDidChange(_ textField: UITextField) {
        let curr = currencySegment.titleForSegment(at: currencySegment.selectedSegmentIndex)!
        if let amountString = textField.text?.currencyInputFormatting(currency: getIndexSymbol(curr:curr)[1]) {
            textField.text = amountString
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView==currencyPicker {
//            //selected currency
//            let curr = currencyPickerData[row]
//
//            //change currency symbol in textview
//            if let amountString = amountTextField.text?.currencyInputFormatting(currency: getIndexSymbol(curr:curr)[1]) {
//                amountTextField.text = amountString
//            }
//            //change start date based on currency
//            let startDate = Int(getIndexSymbol(curr: curr)[2])
//            startPickerData     = [Int](startDate!...2018)
//            startDatePicker.reloadAllComponents()
//            endPickerData       = Array([Int](startDate!...2018).reversed())
//            endDatePicker.reloadAllComponents()
//        }
//    }
    @IBAction func currencySegment(_ sender: UISegmentedControl) {
        //selected currency
        let curr = currencySegment.titleForSegment(at: currencySegment.selectedSegmentIndex)!

        //change currency symbol in textview
        if let amountString = amountTextField.text?.currencyInputFormatting(currency: getIndexSymbol(curr:curr)[1]) {
            amountTextField.text = amountString
        }
        //change start date based on currency
        let startDate = Int(getIndexSymbol(curr: curr)[2])
        startPickerData     = [Int](startDate!...2018)
        startDatePicker.reloadAllComponents()
        endPickerData       = Array([Int](startDate!...2018).reversed())
        endDatePicker.reloadAllComponents()
    }
    
    //MARK: Private functions
    private func getIndexSymbol(curr:String) -> [String] {
        var indice = ""
        var symbol = ""
        var startDate = ""
        switch curr {
        case "USD":
            indice = "USCPI31011913"
            symbol = "$"
            startDate = "1774"
        case "GBP":
            indice = "UKCPI2005"
            symbol = "£"
            startDate = "1751"
        case "ITL":
            indice = "ITCPI2005"
            symbol = "₤"
            startDate = "1861"
        case "FRA":
            indice = "FRCPI1998"
            symbol = "₣"
            startDate = "1901"
        case "ESP":
            indice = "ESCPI2013"
            symbol = "P"
            startDate = "1901"
        case "JPY":
            indice = "JPCPI2010"
            symbol = "¥"
            startDate = "1901"
        default:
            indice = "EUCPI2005"
            symbol = "€"
            startDate = "1901"
        }
        return [indice, symbol, startDate]
    }
    
    //MARK: Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
//        case currencyPicker:
//            return currencyPickerData.count
        case startDatePicker:
            return startPickerData.count
        case endDatePicker:
            return endPickerData.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
//        case currencyPicker:
//            return currencyPickerData[row]
        case startDatePicker:
            return String(startPickerData[row])
        case endDatePicker:
            return String(endPickerData[row])
        default:
            return ""
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        } else {
           return 1
        }
    }

    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if amountTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "You must insert an amount.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if segue.identifier == "resultsSegue" {
            let ResultsTableViewController = (segue.destination as! ResultsTableViewController)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let start = String(startPickerData[startDatePicker.selectedRow(inComponent: 0)])
            let end = String(endPickerData[endDatePicker.selectedRow(inComponent: 0)])
            
            let amount  = String((amountTextField.text?.replacingOccurrences(of: "\\.", with: "", options: .regularExpression).dropFirst(1))!)
//            let curr    = currencyPickerData[currencyPicker.selectedRow(inComponent: 0)]
            let curr = currencySegment.titleForSegment(at: currencySegment.selectedSegmentIndex)!
            let indice  = getIndexSymbol(curr:curr)[0]
            let symbol  = getIndexSymbol(curr:curr)[1]
            
            ResultsTableViewController.amount    = amount
            ResultsTableViewController.currency  = curr
            ResultsTableViewController.start     = start
            ResultsTableViewController.end       = end
            ResultsTableViewController.indice    = indice
            ResultsTableViewController.symbol    = symbol
        }
    }

}
