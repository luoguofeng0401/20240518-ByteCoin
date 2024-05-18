//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "24D6B4DF-BA35-48D4-87F8-DFE67E9227A5"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
                
                //Use optional binding to unwrap the URL that's created from the urlString
                if let url = URL(string: urlString) {
                    
                    //Create a new URLSession object with default configuration.
                    let session = URLSession(configuration: .default)
                    
                    //Create a new data task for the URLSession
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            self.delegate?.didFailWithError(error: error!)
                            return
                        }
                        //Format the data we got back as a string to be able to print it.
                        if let safeDate = data {
                            if let bitcoinPrice = self.parseJSON(safeDate){
                                let priceString = String(format: "%.2f", bitcoinPrice)
                                self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                            }
                        }
                        
                        
                    }
                    //Start task to fetch data from bitcoin average's servers.
                    task.resume()
                }
    }
    
//    func performRequest(with urlString: String) {
//        if let url = URL(string: urlString) {
//            let session = URLSession (configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data {
//                    if let currencyData = self.parseJSON(safeData) {
//                        self.delegate?.didUpdateWeather(self, weather: weather)
//                    }
//                }
//            }
//            task.resume ()
//        }
//    }
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let dacodeData = try decoder.decode(CoinData.self, from: data)
            
            let lastPrice = dacodeData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            print(error)
            return nil
        }
    }
}
