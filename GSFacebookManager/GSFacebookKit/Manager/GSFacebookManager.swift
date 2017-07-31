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
