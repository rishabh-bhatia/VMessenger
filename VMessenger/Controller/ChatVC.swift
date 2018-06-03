//
//  ChatVC.swift
//  VMessenger
//
//  Created by Rishabh Bhatia on 2/6/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageDetail = [MessageDetail]()
    
    var detail: MessageDetail!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient: String!
    
    var messageId: String!
    
    //Setting up tableview Delegates and accessing Data from the account
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.messageDetail.removeAll()
                
                for data in snapshot {
                    
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let info = MessageDetail(messageKey: key, messageData: messageDict)
                        
                        self.messageDetail.append(info)
                    }
                }
            }
            
            self.tableView.reloadData()//Refreshes the table view
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    //S
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDet = messageDetail[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? messageDetailCell {
            
            cell.configureCell(messageDetail: messageDet)
            
            return cell
        } else {
            
            return messageDetailCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recipient = messageDetail[indexPath.row].recipient
        
        messageId = messageDetail[indexPath.row].messageRef.key
        
        performSegue(withIdentifier: "toMessages", sender: nil)
    }
    //Prepares for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MessageVC {
            
            destinationViewController.recipient = recipient
            
            destinationViewController.messageId = messageId
        }
    }
    //Signing out if the button is pressed
    @IBAction func signOut(_ sender: AnyObject) {
        
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        
        dismiss(animated: true, completion: nil)
    }
}

