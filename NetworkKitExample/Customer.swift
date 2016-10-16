//
//  NKEItem.swift
//  NetworkKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alex Telek
//

import UIKit
import NetworkKit


struct Customer: Deserializable {
    var _id = ""
    var firstName = ""
    var lastName = ""
    var address = Dictionary<String, Any>()
    var streetNumber = ""
    var streetName = ""
    var city = ""
    var state = ""
    var zip = ""
    
    init(data: [String : Any]) {
        let _ = _id <-- data["_id"]
        let _ = firstName <-- data["first_name"]
        let _ = lastName <-- data["last_name"]
        let _ = (address <-- data["address"]) as [String: Any]
        let _ = streetNumber <-- address["street_number"]
        let _ = streetName <-- address["street_name"]
        let _ = city <-- address["city"]
        let _ = state <-- address["state"]
        let _ = zip <-- address["zip"]
    }
}
