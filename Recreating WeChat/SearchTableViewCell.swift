//
//  SearchTableViewCell.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/16/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate: class {
    func searchTableViewCellDidAdd(result: String)
}

class SearchTableViewCell: UITableViewCell {

    var nameLabel: UILabel!
    
    let padding: CGFloat = 20
    let labelHeight: CGFloat = 20
    let labelWidth: CGFloat = 60
    
    weak var delegate: SearchTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .orange
        
        contentView.addSubview(nameLabel)
    }
    
    override func updateConstraints() {
        // TODO: Update TableView Cell Constraints for labels and imageView
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            nameLabel.widthAnchor.constraint(equalToConstant: labelWidth)
            ])
        
        super.updateConstraints()
    }
    
    func configure(for result: String) {
        nameLabel.text = result
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
