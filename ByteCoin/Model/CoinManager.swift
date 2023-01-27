//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Hasaan Butt on 23/01/2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateUI( _ coinManager: CoinManager, currency: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4CDF9FB3-94E3-44E1-81E2-C334339FF2DB"
    
    let currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let finalUrl = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: finalUrl)
    }
    
    func performRequest(with urlString:String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                }
                if let safeData = data {
                    if let currency = parseJSON(safeData) {
                        delegate?.didUpdateUI(self, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON( _ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let asset_id_quote = decodedData.asset_id_quote
            let coinModel = CoinModel(rate: lastPrice, asset_id_quote: asset_id_quote)
            return coinModel
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
