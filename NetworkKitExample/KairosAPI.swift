//
//  KairosAPI.swift
//  RockThePayments
//
//  Created by Razvan-Gabriel Geangu on 15/10/2016.
//  Copyright © 2016 Razvan-Gabriel Geangu. All rights reserved.
//

import Foundation
import UIKit
import NetworkKit

class KairosAPI: NSObject {
    
    let app_id = "CHANGE_ME"
    let app_key = "CHANGE_ME"
    
    override init() {
        super.init()
    }
    
    func resizeImage(imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage! as Data
    }
    
    func base64EncodeImage(image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(imageSize: newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithCarriageReturn)
    }
    
    func uploadFace(imageData : String, name : String) {
        
        _ = NKHTTPRequest.POST(
            "https://api.kairos.com/enroll",
            headers: ["app_id": app_id,
                      "app_key": app_key,
                      "Content-Type": "application/json"
            ],
            params: ["image": imageData,
                     "subject_id": name,
                     "gallery_name": "CHANGE_ME",
                     "selector": "SETPOSE",
                     "symmetricFill": "true",
                     "multiple_faces": "false"],
            success: { data in
                print (data)
            },
            failure: { error in
                print(error.message)
        })
    }
    
    func recognizeFace(imageData: String, handler: @escaping (String) -> Void) {
        
        var recognizedName = "NoRecognition"
        
        _ = NKHTTPRequest.POST(
            "https://api.kairos.com/recognize",
            headers: ["app_id": app_id,
                      "app_key": app_key,
                      "Content-Type": "application/json"
            ],
            params: ["image": imageData,
                     "gallery_name": "CHANGE_ME"],
            success: { data in
                var item: RecognizedPerson?
                let _ = item <-- data
                if item?.images != nil {
                    for i in item?.images?[0] as! [String : Any] {
                        if i.key == "candidates" {
                            for key in ((i.value as! NSArray)[0] as! [String : Any]).keys {
                                recognizedName = key
                                handler(recognizedName)
                                break
                            }
                        }
                    }
                } else {
                    recognizedName = "NoRecognition"
                    handler(recognizedName)
                }
            },
            failure: { error in
                print(error.message)
        })
    }
    
    func getMedia() {
        
        _ = NKHTTPRequest.POST(
            "https://api.kairos.com/gallery/view",
            headers: ["app_id": app_id,
                      "app_key": app_key,
                      "Content-Type": "application/json"
            ],
            params: ["gallery_name": "CHANGE_ME"],
            success: { data in
                print(data)
            },
            failure: { error in
                print(error.message)
        })
    }
    
    func removeGallery() {
        
        _ = NKHTTPRequest.POST(
            "https://api.kairos.com/gallery/remove",
            headers: ["app_id": app_id,
                      "app_key": app_key,
                      "Content-Type": "application/json"
            ],
            params: ["gallery_name": "CHANGE_ME"],
            success: { data in
                print(data)
            },
            failure: { error in
                print(error.message)
        })
    }
}
