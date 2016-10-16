//
//  Account.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import Foundation
import NetworkKit


struct Account: Deserializable {
    var _id = ""
    var type = ""
    var nickname = ""
    var rewards = ""
    var balance:Int = 0
    var accountNumber = ""
    var customId = ""
    
    init(data: [String : Any]) {
        let _ = _id <-- data["_id"]
        let _ = type <-- data["type"]
        let _ = nickname <-- data["nickname"]
        let _ = rewards <-- data["rewards"]
        let _ = balance <-- data["balance"]
        let _ = accountNumber <-- data["account_number"]
        let _ = customId <-- data["custom_id"]

    }
}
