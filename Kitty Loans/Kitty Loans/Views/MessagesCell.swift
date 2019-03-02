//
//  MessagesCell.swift
//  MessageApp
//
//  Created by Kasey Schlaudt on 4/29/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var normaMessageLabel: UILabel!
    @IBOutlet weak var normaMessageView: UIView!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var userMessageView: UIView!
    
    var message: Message!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        normaMessageView.backgroundColor = #colorLiteral(red: 0.9490206838, green: 0.9488753676, blue: 0.9618318677, alpha: 1)
        normaMessageLabel.textColor = .black
        userMessageLabel.textColor = .white
        userMessageView.backgroundColor = #colorLiteral(red: 0.01291522849, green: 0.3070249557, blue: 0.9984392524, alpha: 1)
    }
    override func layoutSubviews() {
        userMessageView.layer.cornerRadius = 20
        normaMessageView.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: Message) {
        
        self.message = message
        
        switch message.sender {
        
        case .user:
            
            userMessageView.isHidden = false
            
            normaMessageView.isHidden = true
            
            normaMessageLabel.text = ""
            
            userMessageLabel.text = message.text

            normaMessageLabel.isHidden = true
            
        default:
            normaMessageView.isHidden = false
            
            userMessageView.isHidden = true
            
            userMessageLabel.text = ""
            
            normaMessageLabel.text = message.text
            
            normaMessageLabel.isHidden = false
            
        }
    }

}













