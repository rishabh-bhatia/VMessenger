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


class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollview: UIScrollView!

    @IBOutlet weak var emailField1: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak  var passwordField: UITextField!
    @IBOutlet weak var passwordField1: NSLayoutConstraint!
    
    var userUid: String!
    
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))//Close Keyboard
       self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)//When the keyboard opens
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)//When keyboard Hides
    }
    //Scrolls screen upwards
    @objc func handleKeyboardNotification(notification: Notification) {
      //self.scrollview.isScrollEnabled = false
        self.scrollview.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        }
    //Brings scrolled screen back down whenKeyboard closes
    @objc func keyboardWillHide(notification: Notification) {
        
        self.scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
   /* override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }*/
    //closes keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        return true
    }
    //closes keyboard
   @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    //On screen
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessages" , sender: nil)
        }
    }
    //Preparing for segue
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
//Authorising data
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
