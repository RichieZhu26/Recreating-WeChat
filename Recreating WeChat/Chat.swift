//
//  Chat.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/9/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import Foundation
import UIKit

class Chat {
    var id: String
    var friend: String
    var recentMessage: String
    
    init(id: String, friend: String, recentMessage: String) {
        self.id = id
        self.friend = friend
        self.recentMessage = recentMessage
    }
}
    

