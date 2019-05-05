//
//  MessageCell.swift
//  hackchallenge
//
//  Created by Victor Chen on 5/5/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    var messageTextView: UITextView
    var messageBubbleView: UIView
    
    override init(frame: CGRect) {
        messageBubbleView = UIView()
        messageTextView = UITextView(frame: .zero)
        super.init(frame: .zero)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.font = UIFont.systemFont(ofSize: 18)
        messageTextView.isEditable = false
        messageTextView.textColor = .black
        messageTextView.backgroundColor = .clear
        messageBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageBubbleView.layer.cornerRadius = 15
        messageBubbleView.layer.masksToBounds = true
        contentView.addSubview(messageBubbleView)
        contentView.addSubview(messageTextView)
    }
    
    func configure(for message: Message) {
        messageTextView.text = message.message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
