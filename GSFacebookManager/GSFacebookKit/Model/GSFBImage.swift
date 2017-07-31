//
//  GSFBImage.swift
//  GSFacebookManager
//
//  Created by Sore on 31/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit

class GSFBImage: NSObject {

    var urlString:String! = nil
    var imageSize:CGSize!
    
    init(urlString:String,imageSize:CGSize){
        
        super.init()
        self.urlString = urlString
        self.imageSize = imageSize
        
    }
    
    class func map(json:Any) -> GSFBImage?{
        
        if let dict = json as? [String:Any]{
            
            if let source = dict["source"] as? String{
                
                if let width = dict["width"]{
                    
                    if let height = dict["height"]{
                        
                        let size = CGSize.init(width: width as! CGFloat, height: height as! CGFloat)
                        
                        let imageObj = GSFBImage.init(urlString: source, imageSize: size)
                        
                        return imageObj
                        
                    }
                    
                }
                
            }
            
        }
        
        return nil
        
    }
    
}
