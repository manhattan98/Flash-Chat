//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    // MARK:- Properties
    var messagesBuffer: [Message] = []
    
    var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var isFirstLoad = true
    
    // MARK: - Behaviour
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.hidesBackButton = true
        navigationItem.title = K.appName
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        messageTextfield.delegate = self
                
        startListeningMessages()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.endEditing(true)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            listener = nil
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func sendMessage() {
        if let messageText = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            let msg = Message(from: sender, text: messageText)
            
            Firestore
                .firestore()
                .collection(K.FStore.collectionName)
                .addDocument(data: msg.dictionary) { (error) in
                    if let errorHappened = error {
                        print("Error happened while sending the message")
                        print(errorHappened)
                    } else {
                        DispatchQueue.main.async {
                            // clear message text field after successful sent
                            self.messageTextfield.text = ""
                        }
                    }
                }
        }
    }
    
    func startListeningMessages() {
        if listener != nil {
            return
        }
        listener = Firestore
            .firestore()
            .collection(K.FStore.collectionName)
            .order(by: Message.Keys.date, descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                if let errorHappened = error {
                    print("Error happened while receiving new messages")
                    print(errorHappened)
                }
                if let receivedSnapshot = querySnapshot {
                    self.messagesBuffer = receivedSnapshot.documents.map { (documentSnapshot) -> Message in
                        if let msg = Message(using: documentSnapshot.data()) {
                            return msg
                        } else {
                            fatalError()
                        }
                    }
                    self.tableView.reloadData()
                    
                    self.tableView.scrollToRow(at: IndexPath(row: self.messagesBuffer.count - 1, section: 0), at: .top, animated: !self.isFirstLoad)
                    
                    self.isFirstLoad = false
                }
            }
    }
    
    deinit {
        listener = nil
    }
    
}

// MARK: - UITableViewDataSource conformance
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesBuffer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! MessageCell
        
        let message = messagesBuffer[indexPath.item]
        
        cell.populate(with: message, isMe: Auth.auth().currentUser?.email == message.sender)
        
        return cell
    }
}

// MARK:- UITextFieldDelegate conformance
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return !(textField.text?.isEmpty ?? true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sendMessage()
    }

}
