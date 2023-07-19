//
//  MainVC.swift
//  KeyChainAndUserDefaults
//
//  Created by 2B on 19/07/2023.
//

import UIKit
import KeychainSwift
class MainVC: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTxtField: UITextField!
    //MARK: - Variables
    let defaults = UserDefaults.standard
    let keyChain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    //MARK: - Functions
    func setupUI(){
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        userImage.addGestureRecognizer(tapGesture)
        userImage.isUserInteractionEnabled = true
    }
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func deleteAllUserDefaultsObjects(){
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        showImagePicker()
    }
    //MARK: - IBActions
    @IBAction func saveUsingKeyChainBtn(_ sender: Any) {
        guard let image = userImage.image , let imageData = image.jpegData(compressionQuality: 1.0)else {return}
       
        if keyChain.set(imageData, forKey: Keys.userImage){
            print("Set")
        }else{
            print("did not set")
        }
        guard let username = userNameTxtField.text else {
            return
        }
        keyChain.set(username, forKey: Keys.userName)
    }
    
    @IBAction func saveUsingUserDefaultsBtn(_ sender: Any) {
        if let imageData = userImage.image?.jpegData(compressionQuality: 1.0) {
            defaults.set(imageData, forKey: UserDefaultsConstants.userImage)
        }
        if let userName = userNameTxtField.text {
            defaults.set(userName, forKey: UserDefaultsConstants.userName)
        }
    }
    
    @IBAction func deleteUsingKeyChainBtn(_ sender: Any) {
        keyChain.clear()
    }
    
    @IBAction func deleteUsingUserDefaultsBtn(_ sender: Any) {
        deleteAllUserDefaultsObjects()
    }
    
    @IBAction func navigateToGetDataScreen(_ sender: Any) {
        let vc = GetDataVC()
        present(vc, animated: true)
    }
    
}
 
extension MainVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        userImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
