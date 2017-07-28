//
//  GSFBUser.swift
//  GSFacebookManager
//
//  Created by Sore on 28/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit

class GSFBUser: NSObject {

    var id:String!
    var firstName:String? = nil
    var birthday:String? = nil
    var gender:String? = nil
    
    init(id:String){
        
        super.init()
        self.id = id
        
    }
    
    convenience init(id:String,firstName:String){
        
        self.init(id: id)
        self.firstName = firstName
        
    }
    
    convenience init(id:String,firstName:String?,birthday:String?,gender:String?){
        
        self.init(id: id)
        self.firstName = firstName
        self.birthday = birthday
        self.gender = gender
        
    }
    
    class func map(json:Any) -> GSFBUser?{
        
        if let dict = json as? [String:String]{
            
            if let userId = dict["id"]{
                
                let user = GSFBUser.init(id: userId, firstName: dict["first_name"], birthday: dict["birthday"], gender: dict["gender"])
                
                return user
                
            }
            
            return nil
            
        }
        
        return nil
    }
    
}
