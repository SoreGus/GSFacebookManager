//
//  GSFBPhoto.swift
//  GSFacebookManager
//
//  Created by Sore on 28/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit

class GSFBPhoto: NSObject {

    var id:String!
    var urlString:String!
    var name:String? = nil
    
    init(id:String,urlString:String){
        
        super.init()
        self.id = id
        self.urlString = urlString
        
    }
    
    convenience init(id:String,urlString:String,name:String?){
        
        self.init(id: id,urlString:urlString)
        self.name = name
        
    }
    
    class func map(json:Any) -> GSFBPhoto?{
        
        if let dict = json as? [String:String]{
            
            if let photoId = dict["id"]{
                
                if let urlString = dict["source"]{
                    
                    let photo = GSFBPhoto.init(id: photoId, urlString:urlString, name:dict["name"])
                    
                    return photo
                }
                
                return nil
                
            }
            
            return nil
            
        }
        
        return nil
    }
    
}
