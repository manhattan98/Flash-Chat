//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Eremej Sumcenko on 23.02.2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message {
    enum Keys {
        static let sender = "sender"
        static let message = "message"
        static let date = "date"
    }
    
    let sender: String
    let message: String
    let date: Date
    
    /**
     Create new message using sender and message properties and sending date that is message object creation time
     */
    init(from sender: String, text message: String) {
        self.date = Date()
        self.sender = sender
        self.message = message
    }
    
    /**
     Decode message from dictionary
     */
    init?(using dictionary: [String: Any]) {
        if let sender = dictionary[Keys.sender]! as? String,
           let message = dictionary[Keys.message]! as? String,
           let date = dictionary[Keys.date]! as? Timestamp {
            self.sender = sender
            self.message = message
            self.date = date.dateValue()
        } else {
            return nil
        }
    }
    
    /**
     Return message object encoded to dictionary
     */
    var dictionary: [String: Any] {
        return [
            Keys.sender: sender,
            Keys.message: message,
            Keys.date: date
        ]
    }
}
