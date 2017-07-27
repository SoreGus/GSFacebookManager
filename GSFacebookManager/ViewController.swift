//
//  ViewController.swift
//  GSFacebookManager
//
//  Created by Sore on 27/07/17.
//  Copyright © 2017 Sore. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if GSFacebookManager.isLoggedIn(){
            statusLabel.text = "Online"
            loginButton.isHidden = true
            
            self.loadUser()
            
            
        } else{
            statusLabel.text = "Offline"
        }
    }
    
    func loadUser(){
        
        GSFacebookManager.getUserProfileImage(completion: { (success, stringURL) in
            
            if success == true{
                self.profilePictureImageView.sd_setImage(with: URL.init(string: stringURL!))
            }
            
        })
        
        GSFacebookManager.getUserBasicInfo { (success) in
            
            print("Teste")
            
        }
        
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        
        let additionalPermissions = GSFacebookManager.basicReadPermissions(additionalPermissions: [FBPermissions.kUserBirthday.rawValue])
        
        GSFacebookManager.login(viewController: self, readPermissions: additionalPermissions) { (success) in
            
            if success == false{
                
                DispatchQueue.main.async{
                    self.statusLabel.text = "Offline"
                }
                
            } else{
                
                DispatchQueue.main.async{
                    self.statusLabel.text = "Online"
                    self.loginButton.isHidden = true
                    self.loadUser()
                }
                
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

