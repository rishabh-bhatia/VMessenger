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


class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var userUid: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func SignIn (_sender: AnyObject)
    {
        if let email = emailField.text, let password = passwordField.text
        {
            Auth.auth().signIn(withEmail: email, password:password, completion: { ( user, error) in
                if error == nil {
                    self.userUid = user?.uid
                    
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    
                    performSegue(withIdentifier: "toMessages", sender: nil)
                }
                
                else{
                    performSegue(withIdentifier: "toSignUp", sender: nil)
                }
            })
        }
    }

}
