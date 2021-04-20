//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Eremej Sumcenko on 23.02.2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var yourAvatarImage: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageBubble: UIView!
    
    func populate(with message: Message, isMe: Bool) {
        messageLabel.text = message.message
        
        if isMe {
            avatarImage.isHidden = true
            yourAvatarImage.isHidden = false
            
            messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            messageLabel.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            avatarImage.isHidden = false
            yourAvatarImage.isHidden = true
            
            messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            messageLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageBubble.layer.cornerRadius = messageBubble.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
