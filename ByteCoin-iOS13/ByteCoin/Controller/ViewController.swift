//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
            
            //Remember that we need to get hold of the main thread to update the UI, otherwise our app will crash if we
            //try to do this from a background thread (URLSession works in the background).
            DispatchQueue.main.async {
                self.bitcoinLabel.text = price
                self.currencyLabel.text = currency
            }
        }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectCurrency)
    }
}
