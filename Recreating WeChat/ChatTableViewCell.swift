//
//  ChatTableViewCell.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/9/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    var friendLabel: UILabel!
    var photoImageView: UIImageView!
    var recentMessageLabel: UILabel!
    var timeLabel: UILabel!
    
    let imageSize: CGFloat = 40
    let padding: CGFloat = 10
    let labelHeight: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        friendLabel = UILabel()
        friendLabel.translatesAutoresizingMaskIntoConstraints = false
        
        recentMessageLabel = UILabel()
        recentMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(friendLabel)
        contentView.addSubview(recentMessageLabel)
        
    }
    
    override func updateConstraints() {
        // TODO: Update TableView Cell Constraints for labels and imageView
        NSLayoutConstraint.activate([
            friendLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            friendLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            friendLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        
        NSLayoutConstraint.activate([
            recentMessageLabel.leadingAnchor.constraint(equalTo: friendLabel.leadingAnchor),
            recentMessageLabel.topAnchor.constraint(equalTo: friendLabel.bottomAnchor),
            recentMessageLabel.heightAnchor.constraint(equalTo: friendLabel.heightAnchor)
            ])
        
        super.updateConstraints()
    }
    
    func configure(for chat: Chat) {
        friendLabel.text = chat.friend
        recentMessageLabel.text = chat.mostRecentMessage()?.body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
