//
//  GSFacebookManager.swift
//  GSFacebookManager
//
//  Created by Sore on 27/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class GSFacebookManager: NSObject {

    class func login(viewController:UIViewController,readPermissions:[String]?,completion:@escaping (_ success:Bool)->Void){
        
        var permissions:[String] = []
        
        if readPermissions != nil{
            permissions = readPermissions!
        } else{
            
            permissions = [FBPermissions.kPublicProfile.rawValue,
                           FBPermissions.kUserAboutMe.rawValue,
                           FBPermissions.kEmail.rawValue]
            
        }
        
        if isLoggedIn(readPermissions: permissions) == true{
            completion(true)
            return
        }
        
        FBSDKLoginManager().logIn(withReadPermissions: permissions, from: viewController) { (result, error) in
            
            if error != nil{
                
                completion(false)
                
            } else{
                
                completion(true)
                
            }
        }
    }
    
    class func getUserProfileImage(completion:@escaping (_ success:Bool,_ imageURLString:String?)->Void){
        
        if isLoggedIn() == true{
            
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
                                    
                                } else{
                                    completion(false,nil)
                                }
                                
                            } else{
                                completion(false,nil)
                            }
                            
                        } else{
                           completion(false,nil)
                        }
                    } else{
                        completion(false,nil)
                    }
                    
                }
                
            })
            
        } else{
            
            completion(false,nil)
            
        }
        
    }
    
    class func isLoggedIn() -> Bool{
        
        if FBSDKAccessToken.current() != nil{
            
            return true
            
        }
        
        return false
    }
    
    class func isLoggedIn(readPermissions:[String]) -> Bool{
        
        if FBSDKAccessToken.current() != nil{
            
            for permission in readPermissions{
                if FBSDKAccessToken.current().hasGranted(permission) == false{
                    return false
                }
            }
            
            return true
            
        }
        
        return false
    }
    
}
