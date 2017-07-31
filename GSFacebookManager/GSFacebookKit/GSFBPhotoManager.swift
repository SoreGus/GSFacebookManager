//
//  GSFBPhotoManager.swift
//  GSFacebookManager
//
//  Created by Sore on 31/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class GSFBPhotoManager: NSObject {
    
    class func getUserPhotos(completion:@escaping (_ success:Bool,_ photo:GSFBPhoto?)->Void){
        
        if GSFacebookManager.isLoggedIn() == true{
            
            let params = ["fields" : "photos"]
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
            graphRequest?.start(completionHandler: { (requestConnection , response, error) in
                if error != nil{
                    completion(false,nil)
                    
                } else{
                    
                    if let json = response as? [String:Any]{
                        
                        if let photos = json["photos"] as? [String:Any]{
                            
                            if let data = photos["data"] as? [Any]{
                                
                                for photo in data{
                                    
                                    if let photoJson = photo as? [String:String]{
                                        
                                        let name = photoJson["name"]
                                        
                                        let photoObj = GSFBPhoto.init(id: photoJson["id"]!, name: name)
                                        
                                        self.getPhoto(photoObj: photoObj, completion: { (success, photoObject) in
                                            
                                            completion(success,photoObject)
                                            
                                        })
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    completion(false,nil)
                    
                }
                
                completion(false,nil)
                
            })
            
        } else{
            
            completion(false,nil)
            
        }
        
    }
    
    class func getPhoto(photoId:String,completion:@escaping (_ success:Bool,_ photo:GSFBPhoto?)->Void){
    
        let photoObj = GSFBPhoto.init(id: photoId)
        self.getPhoto(photoObj: photoObj) { (success, photo) in
            
            completion(success,photo)
            
        }
        
    }
    
    class func getPhoto(photoObj:GSFBPhoto,completion:@escaping (_ success:Bool,_ photo:GSFBPhoto?)->Void){
        
        if GSFacebookManager.isLoggedIn() == true{
            
            let params = ["fields" : "images"]
            let graphRequest = FBSDKGraphRequest(graphPath: photoObj.id, parameters: params)
            graphRequest?.start(completionHandler: { (_ , response, error) in
                
                if error != nil{
                    
                    completion(false,nil)
                    
                } else{
                    
                    if let photo = response as? [String:Any]{
                        
                        if let images = photo["images"] as? [Any]{
                            
                            for img in images{
                                
                                let imageObj = GSFBImage.map(json: img)
                                
                                photoObj.images.append(imageObj!)
                                
                            }
                            completion(true,photoObj)
                            return
                            
                        }
                        
                    }
                    completion(false,nil)
                    
                }
                
                completion(false,nil)
                
            })
            
        } else{
            
            completion(false,nil)
            
        }
        
    }

}
