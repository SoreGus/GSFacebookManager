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
    
    static let kReadPermissionsKey = "read_permissions"

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
                
                self.saveReadPermissions(permissions: permissions)
                completion(true)
                
            }
        }
    }
    
    class func basicReadPermissions(additionalPermissions:[String]) -> [String]{
        
        var permissions:[String] = [FBPermissions.kPublicProfile.rawValue,
                           FBPermissions.kUserAboutMe.rawValue,
                           FBPermissions.kEmail.rawValue]
        
        for permission in additionalPermissions{
            
            permissions.append(permission)
            
        }
        
        return permissions
        
    }
    
    class func saveReadPermissions(permissions:[String]){
        
        UserDefaults.standard.set(permissions, forKey: kReadPermissionsKey)
        
    }
    
    class func clearReadPermissions(){
        
        UserDefaults.standard.set(nil, forKey: kReadPermissionsKey)
        
    }
    
    class func getReadPermissions() -> [String]?{
        
        if let permissions = UserDefaults.standard.object(forKey: kReadPermissionsKey) as? [String]{
            return permissions
        }
        
        return nil
        
    }
    
    class func logout(){
        
        FBSDKLoginManager().logOut()
        self.clearReadPermissions()
        
    }
    
    class func getUserBasicInfo(completion:@escaping (_ success:Bool)->Void){
        
        if let permissions = self.getReadPermissions(){
            
            if self.isLoggedIn(readPermissions: permissions){
                
                let params = ["fields" : "gender,birthday,first_name"]
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
                graphRequest?.start(completionHandler: { (request, response, error) in
                    
                    if error != nil{
                        
                        completion(false)
                        
                    } else{
                        
                        print(response)
                        
                    }
                    
                    completion(false)
                    
                })
                
            } else{
                completion(false)
            }
            
        } else{
            completion(false)
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
