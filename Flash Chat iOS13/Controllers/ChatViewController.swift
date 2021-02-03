//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var Messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.title
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages(){

        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{ (querySnapshot, error) in
            self.Messages = []
            if let e = error{
                print("There was ERROR in reading data from database, \(e)")
            }else {
                if let documentSnapShots = querySnapshot?.documents{
                    for docs in documentSnapShots{
                        let data = docs.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.Messages.append(newMessage)
            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.Messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                    }
                }
            }
                
        }
    }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let user = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.bodyField: messageBody,
                                                                      K.FStore.senderField: user,
                                                                      K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                                                                        if let e = error{
                                                                            print("There is ERROR in adding data in database, \(e)")
                                                                        }else{
                                                                            print("Succesfully added message in data base")
                                                                        }
            }
        }
        messageTextfield.text = ""
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
    
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = Messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftAvatar.isHidden = true
            cell.rightAvatar.isHidden = false
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.MessageLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }else {
            cell.leftAvatar.isHidden = false
            cell.rightAvatar.isHidden = true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.MessageLabel.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        cell.MessageLabel.text = message.body
        return cell
    }
    
}
