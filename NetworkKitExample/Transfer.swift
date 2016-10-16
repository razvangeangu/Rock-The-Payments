//
//  Transfer.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 16/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import Foundation
import NetworkKit
struct Transfer: Deserializable {
    
    var _id = ""
    var type = ""
    var transactionDate = ""
    var status = ""
    var medium = ""
    var payerId = ""
    var payeeId = ""
    var amount:Double = 0
    var description = ""
    
    init(data: [String : Any]) {
        let _ = _id <-- data["_id"]
        let _ = type <-- data["type"]
        let _ = transactionDate <-- data["transaction_date"]
        let _ = status <-- data["status"]
        let _ = medium <-- data["medium"]
        let _ = payerId <-- data["payer_id"]
        let _ = payeeId <-- data["payee_id"]
        let _ = amount <-- data["amount"]
        let _ = description <-- data["description"]
    }
}
