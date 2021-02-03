//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Yash  on 05/07/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var MessageBubble: UIView!
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var rightAvatar: UIImageView!
    @IBOutlet weak var leftAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MessageBubble.layer.cornerRadius = MessageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
