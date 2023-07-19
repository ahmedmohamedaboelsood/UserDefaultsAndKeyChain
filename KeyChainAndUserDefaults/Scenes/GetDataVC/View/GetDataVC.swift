//
//  GetDataVC.swift
//  KeyChainAndUserDefaults
//
//  Created by 2B on 19/07/2023.
//

import UIKit
import KeychainSwift
class GetDataVC: UIViewController {
//MARK: - IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    //MARK: - Variables
    let keyChain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
 //MARK: - Functions
    func setupUI(){
        userImage.layer.cornerRadius = userImage.bounds.height / 2
    }
    
    func fetchImageFromUserDefaults() -> UIImage? {
        if let imageData = defaults.data(forKey: UserDefaultsConstants.userImage),
           let image = UIImage(data: imageData) {
            return image
        }
        return UIImage(systemName:"person.circle.fill")
    }
    
    func fetchUserName()->String?{
        if let userName = defaults.string(forKey: UserDefaultsConstants.userName){
            return "Name : \(userName)"
        }
        return "Name : N/A"
    }
    
    //MARK: - IBActions
    @IBAction func GetdatfromUserDefaults(_ sender: Any) {
        userImage.image = fetchImageFromUserDefaults()
        usernameLbl.text = fetchUserName()
    }
    
    @IBAction func GetdatfromKeyChain(_ sender: Any){
        if let imageData = keyChain.getData(Keys.userImage) {
            let image = UIImage(data: imageData)
            userImage.image = image
        }else{
            let image = UIImage(systemName:"person.circle.fill")
            userImage.image = image
        }
        
        if let userName = keyChain.get(Keys.userName){
            usernameLbl.text = "Name : \(userName)"
        } else {
            usernameLbl.text = "Name : N/A"
        }
    }
}
