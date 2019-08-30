//
//  MessageTableViewCell.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/28/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var senderLabel: UILabel!
    var bodyLabel: UILabel!
    
    let padding: CGFloat = 10
    let labelHeight: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        senderLabel = UILabel()
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(senderLabel)
        contentView.addSubview(bodyLabel)
        
    }
    
    override func updateConstraints() {
        // TODO: Update TableView Cell Constraints for labels and imageView
        NSLayoutConstraint.activate([
            senderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            senderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            senderLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: senderLabel.trailingAnchor, constant: padding),
            bodyLabel.topAnchor.constraint(equalTo: senderLabel.topAnchor),
            bodyLabel.heightAnchor.constraint(equalTo: senderLabel.heightAnchor)
            ])
        
        super.updateConstraints()
    }
    
    func configure(for message: Message) {
        senderLabel.text = message.sender
        bodyLabel.text = message.body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
