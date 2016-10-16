//
//  Purchase.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import Foundation
import NetworkKit


struct Purchase: Deserializable {
    
    var _id = ""
    var type = ""
    var merchantId = ""
    var payerId = ""
    var purchaseDate = ""
    var amount:Double = 0
    var status = ""
    var medium = ""
    var description = ""

    init(data: [String : Any]) {
        let _ = _id <-- data["_id"]
        let _ = type <-- data["type"]
        let _ = merchantId <-- data["merchant_id"]
        let _ = payerId <-- data["payer_id"]
        let _ = purchaseDate <-- data["purchase_date"]
        let _ = amount <-- data["amount"]
        let _ = status <-- data["status"]
        let _ = medium <-- data["medium"]
        let _ = description <-- data["description"]

    }
    
    init() {
        
    }
}
