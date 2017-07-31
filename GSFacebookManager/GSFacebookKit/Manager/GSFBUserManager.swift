//
//  GSFBUserManager.swift
//  GSFacebookManager
//
//  Created by Sore on 31/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class GSFBUserManager: NSObject {

    class func getUserBasicInfo(completion:@escaping (_ success:Bool,_ user:GSFBUser?)->Void){
        
        if let permissions = GSFacebookManager.getReadPermissions(){
            
            if GSFacebookManager.isLoggedIn(readPermissions: permissions){
                
                let params = ["fields" : "gender,birthday,first_name"]
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
                graphRequest?.start(completionHandler: { (_ , response, error) in
                    
                    if error != nil{
                        
                        completion(false,nil)
                        return
                        
                    } else{
                        
                        completion(true,GSFBUser.map(json: response!))
                        return
                        
                    }
                    
                })
                
            } else{
                completion(false,nil)
                return
            }
            
        } else{
            completion(false,nil)
            return
        }
        
    }
    
    class func getUserProfileImage(completion:@escaping (_ success:Bool,_ imageURLString:String?)->Void){
        
        if GSFacebookManager.isLoggedIn() == true{
            
            let params = ["fields" : "picture"]
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
            graphRequest?.start(completionHandler: { (request, response, error) in
                
                if error != nil{
                    
                    completion(false,nil)
                    
                } else{
                    
                    if let json = response as? [String:Any]{
                        
                        if let picture = json["picture"] as? [String:Any]{
                            
                            if let data = picture["data"] as? [String:Any]{
                                
                                if let urlString = data["url"] as? String{
                                    
                                    completion(true,urlString)
                                    return
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                
                completion(false,nil)
                
            })
            
        } else{
            
            completion(false,nil)
            
        }
        
    }
    
}
