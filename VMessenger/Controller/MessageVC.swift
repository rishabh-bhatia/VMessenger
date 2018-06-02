//
//  MessageVC.swift
//  VMessenger
//
//  Created by Rishabh Bhatia on 2/6/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageID: String!
    var recipient: String!
    
    var messages = [Message]()
    
    var message: Message!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        if messageID != "" && messageID != nil{
            loadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell {
            cell.configureCell(message: message)
            
            return cell
        }
        else {
            return MessagesCell()
        }
    }
}


