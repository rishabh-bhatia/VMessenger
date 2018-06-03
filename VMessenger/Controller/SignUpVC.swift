//
//  SignUpVC.swift
//  VMessenger
//
//  Created by Rishabh Bhatia on 21/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var userImagePicker: UIImageView!
    
    @ IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    var userUid: String!
    var username: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
    }
    //Keyboard handeling
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //Keyboard handeling
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameField.resignFirstResponder()
    }
    //preparing for segue
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessages" , sender: nil)
        }
    }
    //To choose profile picture for new account
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            userImagePicker.image = image
            imageSelected = true
        }
        
        else {
            print("No image has been Selected. Please select an Image.")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //Setting up the username
    func setUser(img: String){
        
        let userData = [
            "username" : username!,
            "userImg": img
        ]
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //Uploads the image to firebase
    
    func uploadImg(){
        if usernameField.text == nil{
            signUpBtn.isEnabled = false
        }
        
        else{
            username = usernameField.text
            
            signUpBtn.isEnabled = true
        }
        
        guard let img = userImagePicker.image, imageSelected == true
        
            else {
                
                print ("Please select an Image")
                
                return
        }
        
        if let imgData = UIImageJPEGRepresentation(img,0.2){
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata)
            {
                (metadata, error) in
                if error != nil {
                    print("Image can't be uploaded")
                }
                
                else {
                    print("Upload successful!")
                    
                    let  downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let  url = downloadURL {
                        
                        self.setUser(img: url)
                    }
                    
                    
                }
            }
        }
    }
    //Performing Segue to another View Controller
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey:  "uid"){
            performSegue(withIdentifier: "toMessage", sender: nil)
        }
    }
    
    @IBAction func createAccount(_ sender: AnyObject){
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: {(user, error)in
            
            if error != nil {
                print("Sorry,  User can't be created!")
            }
            
            else
            {
                if let user = user {
                    self.userUid = user.uid
                }
            }
            
            self.uploadImg()
        })
    }
    //To cancel registeration
    @IBAction func  cancel ( _ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
    //Choosing Image
    @IBAction func selectedImagePicker( _ sender: AnyObject){
        present(imagePicker, animated: true , completion: nil )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
