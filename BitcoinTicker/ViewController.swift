//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Siddharth Paneri on 02/01/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    let array_Currency : [[String:String]] = [["K":"AUD", "S": "$"],
                                              ["K":"BRL", "S": "R$"],
                                              ["K":"CAD", "S": "$"],
                                              ["K":"CNY", "S": "¥"],
                                              ["K":"EUR", "S": "€"],
                                              ["K":"GBP", "S": "£"],
                                              ["K":"HKD", "S": "$"],
                                              ["K":"IDR", "S": "Rp"],
                                              ["K":"ILS", "S": "₪"],
                                              ["K":"INR", "S": "₹"],
                                              ["K":"JPY", "S": "¥"],
                                              ["K":"MXN", "S": "$"],
                                              ["K":"NOK", "S": "kr"],
                                              ["K":"NZD", "S": "$"],
                                              ["K":"PLN", "S": "zł"],
                                              ["K":"RON", "S": "lei"],
                                              ["K":"RUB", "S": "₽"],
                                              ["K":"SEK", "S": "kr"],
                                              ["K":"SGD", "S": "$"],
                                              ["K":"USD", "S": "$"],
                                              ["K":"ZAR", "S": "R"]]

    var displaySymbol = ""
    
    @IBOutlet weak var label_price: UILabel!
    @IBOutlet weak var picker_PriceConverter: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker_PriceConverter.delegate = self
        picker_PriceConverter.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        label_price.text = "Select currency"
    }

    func getBitcoinPrices(url: String) {
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success: \(response.result)")
                let json = JSON(response.result.value!)
                self.updateUI(using: json)
            } else {
                print("Error: - \(String(describing: response.result.error))")
                self.label_price.text = "Connection issues"
            }
        }
    }
    func updateUI(using json: JSON) {
        if let btcResult = json["ask"].double {
            label_price.text = "\(displaySymbol) " + String(btcResult)
        } else {
            label_price.text = "Price unavailable"
        }
    }

}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.array_Currency.count
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array_Currency[row]["K"]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let finalURL = baseURL + array_Currency[row]["K"]!
        displaySymbol = array_Currency[row]["S"]!
        print(finalURL)
        getBitcoinPrices(url: finalURL)
    }
}

