//
//  PurchasesViewController.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import NetworkKit
import AVFoundation

class PurchaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let userId = "580265d7360f81f104543eb0";
    let capitalOne:CapitalOne = CapitalOne()
    var purchases:[Purchase] = []
    var transfers:[Transfer] = []
    let defaults = UserDefaults.standard
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.didReceiveMemoryWarning()
        table.delegate = self
        table.dataSource = self
        
        
        // Creating a blur effect with dark style
        let blurEffect = UIBlurEffect(style: .dark)
        // Creating a view for the blur effect with the same size of labels view
        let f = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let blurView = UIVisualEffectView(frame: f)
        // Add effect for the blur view
        blurView.effect = blurEffect
        blurView.alpha = 0.40
        // Insert the blur layer below our existing labels
        backImage.insertSubview(blurView, aboveSubview: self.view)
        
        
        capitalOne.getAllMerchants { (merchants) in
            for m in merchants {
                self.defaults.set([m.name,"\(m.lat)","\(m.lon)",m.streetName,m.streetNumber,m.city], forKey: m._id)
            }
            
            self.capitalOne.getAccountForAccountId(userId: self.userId, { (Account) in
                self.balanceLabel.text = "£\(Account.balance)"
            })
            
            self.capitalOne.getPurchasesForId(userId: self.userId) { (purchases) in
                self.purchases = purchases
            }
            
            self.capitalOne.getTransfersForUser(userId: self.userId, { (transfers) in
                self.transfers = transfers
                for t in transfers{
                    var p:Purchase = Purchase()
                    p._id = t._id
                    p.amount = Double(t.amount)
                    p.purchaseDate = t.transactionDate
                    p.merchantId = t.payeeId
                    p.medium = "transfer"
                    
                    //                    self.capitalOne.getCustomerForId(customerId: t.payeeId, { (Customer) in
                    //                        self.defaults.set([Customer.lastName, Customer.firstName], forKey: t.payeeId)
                    //                        print("Customer")
                    //
                    //                        print(Customer)
                    //                    })
                    
                    self.purchases.append(p)
                }
                self.table.reloadData()
            })
        }
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PurchaseDetailsViewController {
            
            let s = segue.destination as! PurchaseDetailsViewController
            let descr = purchases[((table.indexPathForSelectedRow)?.row)!].description
            s.des = descr
            
            let mId = purchases[((table.indexPathForSelectedRow)?.row)!].merchantId
            let array = defaults.value(forKey: mId) as! [String]
            s.address = "\(array[4]), \(array[3]), \(array[5])"
            print("\(array[4]), \(array[3]), \(array[5])")
            s.tit = array[0]
            s.price = "£\(purchases[((table.indexPathForSelectedRow)?.row)!].amount)"
            print(array[1])
            s.lat = array[1]
            print(array[2])
            s.long = array[2]
        }
        
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
    }
    
    // MARK: - Table view data source
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? PurchasesCellTableViewCell
        if(purchases[indexPath.row].medium  == ("balance")){
            
            let m = defaults.value(forKey: purchases[indexPath.row].merchantId) as! [String]
            cell?.merchantLabel.text = m[0]
            cell?.priceLabel.text = "- £\(purchases[indexPath.row].amount)"
            cell?.priceLabel.layer.borderColor = UIColor(red: 255/255, green: 123/255, blue: 139/255, alpha: 1).cgColor
            cell?.priceLabel.textColor = UIColor(red: 255/255, green: 123/255, blue: 139/255, alpha: 1)
            
        } else {
            cell?.priceLabel.layer.borderColor = UIColor(red: 136/255, green: 255/255, blue: 120/255, alpha: 1).cgColor
            cell?.priceLabel.textColor = UIColor(red: 136/255, green: 255/255, blue: 120/255, alpha: 1)
            cell?.priceLabel.text = "+ £\(purchases[indexPath.row].amount)"
            cell?.merchantLabel.text = "Pietro Calzini"
        }
        cell?.dateLabel.text = purchases[indexPath.row].purchaseDate
        return cell!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = backImage.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var input : AVCaptureDeviceInput!
        
        do {
            try input = AVCaptureDeviceInput(device: backCamera)
        } catch {
            NSLog("error")
        }
        
        if (captureSession?.canAddInput(input) != nil){
            
            captureSession?.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (captureSession?.canAddOutput(stillImageOutput) != nil){
                captureSession?.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                backImage.layer.addSublayer(previewLayer!)
                // Creating a blur effect with dark style
                let blurEffect = UIBlurEffect(style: .dark)
                // Creating a view for the blur effect with the same size of labels view
                let f = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                let blurView = UIVisualEffectView(frame: f)
                // Add effect for the blur view
                blurView.effect = blurEffect
                blurView.alpha = 1.0
                // Insert the blur layer below our existing labels
                backImage.insertSubview(blurView, aboveSubview: self.view)
                captureSession?.startRunning()
                
            }
        }
    }
}

