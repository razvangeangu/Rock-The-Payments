//
//  ViewController.swift
//  NetworkKitExample
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alex Telek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import AVFoundation
import PusherSwift
import NetworkKit

class NKEViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraFeed: UIImageView!
    @IBOutlet weak var recognizedName: UILabel!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var recognizedNameButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var setAmountButton: UIButton!
    
    
    let kairos = KairosAPI()
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    let capitalOne : CapitalOne =  CapitalOne();
    var merchantId:String = "57cf75cea73e494d8675ec58"
    var customerCode:String = ""
    var accountCode:String = ""
    let pusher = Pusher(key: "4da4d89351216a5d1869")
    let userId = "580265d7360f81f104543eb0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pusherConnect()
        doStyle()
        capitalOneGetters()
    }
    
    func capitalOneGetters() {
        capitalOne.getCustomers { (customers) in
            
            self.customerCode = customers[0]._id
            print("Customer: \(self.customerCode)")
            
            self.capitalOne.getAccountForId(userId: self.customerCode, { (accounts) in
                self.accountCode = accounts[0]._id
                print("Account: \(self.accountCode)")
            })
            
        }
        
        capitalOne.getAllMerchants { (merchants) in
            
            self.merchantId = merchants[0]._id
            print("Merchant: \(self.merchantId)")
        }
        
        
        //        capitalOne.getAllMerchants()
        //        capitalOne.createAccount(userId: "58023544360f81f104543e95", type: "Credit Card", nickname: "Pietro'sAccount", rewards: 0, balance: 10000, accountNumber: "1231231231231231")
    }
    
    func doStyle() {
        setAmountButton.layer.cornerRadius = 7
        recognizedNameButton.setTitle("", for: UIControlState.normal)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraFeed.bounds
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
                cameraFeed.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
                
            }
        }
    }
    
    @IBAction func takePicture(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.cameraFeed.alpha = 0.0
            self.view.backgroundColor = UIColor.white
        })
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.cameraFeed.alpha = 1.0
            self.view.backgroundColor = UIColor.clear
        })
        
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput!.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
//                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
                
                let imageEncoded = self.kairos.base64EncodeImage(image: UIImage(data: imageData!)!)
                
                SwiftSpinner.show("Recognizing")
                self.kairos.recognizeFace(imageData: imageEncoded, handler: { (name) in
                    self.recognizedName.text = name
                    self.recognizedName.isHidden = false
                    self.recognizedNameButton.setTitle("Make payment", for: UIControlState.normal)
                    if (self.amountField.isHidden) {
                        self.recognizedNameButton.isHidden = false
                    }
                    SwiftSpinner.hide()
                    UIView.animate(withDuration: 0.7, delay: 2.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                        self.recognizedName.alpha = 0
                        }, completion: nil)
                })
            }
        }
    }
    
    func pusherConnect() {
        
        
        // subscribe to channel and bind to event
        let channel = pusher.subscribe("test_channel")
        
        let _ = channel.bind(eventName: "my_event", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let name = data["name"] as? String {
                    self.alert(message: "A payment has been made to: \(name)")
                } else {
                    self.alert(message: "no name")
                }
            }
        })
        
        pusher.connect()
    }
    
    @IBAction func amountButtonPressed(_ sender: AnyObject) {
        amountField.isHidden = false
        setAmountButton.isHidden = false
        amountButton.isHidden = true
        recognizedNameButton.isHidden = true
    }
    
    @IBAction func setAmountButtonPressed(_ sender: AnyObject) {
        let newTitle = amountField.text!
        amountButton.setTitle("£\(newTitle)", for: UIControlState.normal)
        setAmountButton.isHidden = true
        amountField.isHidden = true
        amountButton.isHidden = false
        recognizedNameButton.isHidden = false
        amountField.resignFirstResponder()
    }
    
    @IBAction func makePayment(_ sender: AnyObject) {
        let encodedName = recognizedName.text!
        let amount = amountField.text!
        let amountNumber = Int(amount)!
        amountField.text = ""
        
        _ = NKHTTPRequest.GET(
            "http://pusher.phpnet.us/makepayment.php",
            params: ["name": encodedName],
            success: { data in
                
                SwiftSpinner.show(duration: 2, title: "Making Payment")
                self.capitalOne.createPurchase(userId: self.userId, merchantId: self.merchantId, medium: "balance", purchaseDate: "2016-11-16", amount: amountNumber, description: "Apple Inc.")
                
                self.alert(message: "Payment succesful")
            },
            failure: { error in
                print(error.message)
        })
    }
    
}

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

