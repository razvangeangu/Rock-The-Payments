//
//  CapitalOne.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import Foundation
import NetworkKit
class CapitalOne{
    
    let apiKey = "c6af915fa5691d0f1ecc8af4b4f3dc11"
    
    //Create a new customer
    //** SET STATE AND ZIP AS REAL STATE CODE AND ZIP - SUGGESTED: state"CA", zip"90201"
    func createCustomer(firstName: String, lastName: String, streetNumber: String, streetName: String, city: String, state: String, zip: String){
        _ = NKHTTPRequest.POST("http://api.reimaginebanking.com/customers?key=\(apiKey)",
            params: [
                "first_name": firstName,
                "last_name": lastName,
                "address": [
                    "street_number": streetNumber,
                    "street_name": streetName,
                    "city": city,
                    "state": state,
                    "zip": zip
                ]
            ],
            success: { data in
                var c:Customer?
                let _ = c <-- data
                print(c?.firstName)
            },
            failure: { error in
                print(error.message)
        })
    }
    
    func getCustomers(_ completionHandler: @escaping ([Customer]) -> Void) {
        var customers:[Customer] = []
        _ = NKHTTPRequest.GET(
            "http://api.reimaginebanking.com/customers?key=\(apiKey)",
            params: nil,
            success: { data in
                
                for item in (data as! [AnyObject]) {
                    
                    var customer: Customer?
                    let _ = customer <-- item
                    customers.append(customer!)
                }
                
                completionHandler(customers)
            },
            failure: { error in
                print(error.message)
        })
    }
    
    func getCustomerForId(customerId:String, _ completionHandler: @escaping (Customer) -> Void) {
        _ = NKHTTPRequest.GET(
            "http://api.reimaginebanking.com/customers/\(customerId)?key=\(apiKey)",
            params: nil,
            success: { data in
                
                var customer: Customer?
                let _ = customer <-- data
                
                completionHandler(customer!)
            },
            failure: { error in
                print(error.message)
        })
    }
    
    func getAllMerchants(_ completionHandler: @escaping ([Merchant]) -> Void){
        var merchants:[Merchant] = []
        
        _ = NKHTTPRequest.GET(
            "http://api.reimaginebanking.com/merchants?key=\(apiKey)",
            params: nil,
            success: { data in
                let d = (data as! [String: AnyObject])["data"]
                
                for item in (d as! [AnyObject]) {
                    
                    var merchant: Merchant?
                    let _ = merchant <-- item
                    merchants.append(merchant!)
                }
                
                completionHandler(merchants)
            },
            failure: { error in
                print(error.message)
        })
    }
    
    
    func createPurchase(userId:String, merchantId: String, medium: String, purchaseDate: String, amount: Int, description: String){
        _ = NKHTTPRequest.POST("http://api.reimaginebanking.com/accounts/\(userId)/purchases?key=\(apiKey)",
            params: [
                "merchant_id": merchantId,
                "medium": medium,
                "purchase_date": purchaseDate,
                "amount": amount,
                "description": description
            ],
            success: { data in
                
                print(data)
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
    func createAccount(userId:String, type: String, nickname: String, rewards: Int, balance: Int, accountNumber: String){
        _ = NKHTTPRequest.POST("http://api.reimaginebanking.com/customers/\(userId)/accounts?key=\(apiKey)",
            params: [
                "type": type,
                "nickname": nickname,
                "rewards": rewards,
                "balance": balance,
                "account_number": accountNumber
            ],
            success: { data in
                
                print(data)
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
    func getAccountForAccountId(userId:String, _ completionHandler: @escaping (Account) -> Void){
        _ = NKHTTPRequest.GET("http://api.reimaginebanking.com/accounts/\(userId)?key=\(apiKey)",
            params: nil,
            success: { data in
                
                var account: Account?
                let _ = account <-- data
                
                completionHandler(account!)
                
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
    
    func getAccountForId(userId:String, _ completionHandler: @escaping ([Account]) -> Void){
        var accounts:[Account] = []
        _ = NKHTTPRequest.GET("http://api.reimaginebanking.com/customers/\(userId)/accounts?key=\(apiKey)",
            params: nil,
            success: { data in
                for item in (data as! [AnyObject]) {
                    var account: Account?
                    let _ = account <-- item
                    accounts.append(account!)
                }
                completionHandler(accounts)
                
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
    func getTransfersForUser(userId:String, _ completionHandler: @escaping ([Transfer]) -> Void){
        var transfers:[Transfer] = []
        _ = NKHTTPRequest.GET("http://api.reimaginebanking.com/accounts/\(userId)/transfers?key=\(apiKey)",
            params: nil,
            success: { data in
                for item in (data as! [AnyObject]) {
                    var transfer: Transfer?
                    let _ = transfer <-- item
                    transfers.append(transfer!)
                }
                completionHandler(transfers)
                
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
    func getPurchasesForId(userId:String, _ completionHandler: @escaping ([Purchase]) -> Void){
        var purchases:[Purchase] = []
        _ = NKHTTPRequest.GET("http://api.reimaginebanking.com/accounts/\(userId)/purchases?key=\(apiKey)",
            params: nil,
            success: { data in
                for item in (data as! [AnyObject]) {
                    var purchase: Purchase?
                    let _ = purchase <-- item
                    purchases.append(purchase!)
                }
                completionHandler(purchases)
                
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
    func createTransferForId(accountId:String, description:String, date:String, amount: Int, receiverId: String,_ completionHandler: @escaping ([Purchase]) -> Void){
        _ = NKHTTPRequest.POST("http://api.reimaginebanking.com/accounts/\(accountId)/transfers?key=\(apiKey)",
            params: [
                "medium": "balance",
                "payee_id": receiverId,
                "amount":amount,
                "transaction_date": date,
                "description": description
            ],
            success: { data in
                print(date)
                
            },
            failure: { error in
                print(error.message)
        })
        
    }
    
}
