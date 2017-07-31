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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginButton: UIButton!
    
    internal var arrayPhotos:[GSFBPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        
        GSFacebookManager.getUserBasicInfo { (success,user) in
            
            if success == true{
                print(user!)
            }
            
        }
        
        GSFacebookManager.getUserPhotos { (success, photo) in
            
            if success == true{
                self.arrayPhotos.append(photo!)
                self.collectionView.reloadData()
            }
            
        }
        
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        
        let additionalPermissions = GSFacebookManager.basicReadPermissions(additionalPermissions: [FBPermissions.kUserBirthday.rawValue,FBPermissions.kUserPhotos.rawValue])
        
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

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        
        let photo = self.arrayPhotos[indexPath.row]
        
        cell.imageView.sd_setImage(with: URL.init(string: photo.urlString))
        cell.imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell
        
    }
    
}

