//
//  ViewController.swift
//  VMessenger
//
//  Created by Rishabh Bhatia on 29/4/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class LoginVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var userUid: String!
    
    var activeTextField : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
        

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessages" , sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp" {
            if let destination = segue.destination as? SignUpVC {
                if self.userUid != nil {
                    destination.userUid = userUid
                }
                
                if self.emailField.text != nil {
                    destination.emailField = emailField.text
                }
                
                if self.passwordField.text != nil {
                    destination.passwordField = passwordField.text
                }
        }
    }
    }

        @IBAction func SignIn (_ sender: AnyObject)
    {
        if let email = emailField.text, let password = passwordField.text
        {
            Auth.auth().signIn(withEmail: email, password:password, completion: { ( user, error) in
                if error == nil {
                    self.userUid = user?.uid
                    
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    
                    self.performSegue(withIdentifier: "toMessages", sender: nil)
                }
                
                else{
                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                }
            })
        }
    }
    
    

}
