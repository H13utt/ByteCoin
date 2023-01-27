//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Hasaan Butt on 23/01/2022.
//

import Foundation

struct CoinModel {
    let rate: Double
    let asset_id_quote: String
    var stringRate: String {
        return String(format: "%.2f", rate)
    }
}
