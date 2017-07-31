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
    var images:[GSFBImage] = []
    var name:String? = nil
    
    init(id:String){
        
        super.init()
        self.id = id
        
    }
    
    init(id:String,name:String?){
        
        super.init()
        self.id = id
        self.name = name
        
    }
    
    class func map(json:Any) -> GSFBPhoto?{
        
        if let dict = json as? [String:String]{
            
            if let photoId = dict["id"]{
                
                if let urlString = dict["source"]{
                    
                    let photo = GSFBPhoto.init(id: photoId, name:dict["name"])
                    
                    return photo
                }
                
                return nil
                
            }
            
            return nil
            
        }
        
        return nil
    }
    
    func getSmallerImage() -> GSFBImage?{
        
        if images.count > 0{
            
            var smallerImage:GSFBImage = images[0]
            
            for image in images{
                
                if smallerImage.imageSize.width > image.imageSize.width{
                    smallerImage = image
                }
                
            }
            
            return smallerImage
            
        }
        
        return nil
        
    }
    
}
