//
//  PurchaseDetailsViewController.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit
import MapKit
class PurchaseDetailsViewController: UIViewController {

    @IBOutlet var merchantLabel: UILabel!
    var tit:String = ""
    
    @IBOutlet var map: MKMapView!

    @IBOutlet var descLabel: UILabel!
    var des:String = ""

    @IBOutlet var addresslabel: UILabel!
    var address:String = ""

    @IBOutlet var priceLabel: UILabel!
    var price:String = ""
    var lat:String = ""
    var long: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        openMapForPlace(lat: lat as NSString, long: long as NSString)
        merchantLabel.text = tit
        descLabel.text = des
        addresslabel.text = address
        priceLabel.text = price
        
        descLabel.layer.borderColor = UIColor.white.cgColor
        descLabel.layer.borderWidth = 2.0
        descLabel.layer.cornerRadius = 8.0
        
        let bottom = UIColor(red: 69/255, green: 106/255, blue: 214/255, alpha: 1)
        let top = UIColor(red: 60/255, green: 141/255, blue: 255/255, alpha: 1)
        
        let gradientColor : [CGColor] = [top.cgColor, bottom.cgColor]
        let gradientLocations : [Float] = [0.20,1.0]
        
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = UIScreen.main.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    func openMapForPlace(lat: NSString,long: NSString) {
        
        let latitute:CLLocationDegrees =  lat.doubleValue
        let longitute:CLLocationDegrees =  long.doubleValue
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
       
        let myAnnotation : MapPin = MapPin(latitude: latitute,longitude: longitute)
        myAnnotation.title = tit
        myAnnotation.subtitle = price
        map.addAnnotation(myAnnotation)
        map.setRegion(regionSpan, animated: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
