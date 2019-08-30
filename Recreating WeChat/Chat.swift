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
    var messages: [Message]
    
    init(id: String, friend: String, messages: [Message]) {
        self.id = id
        self.friend = friend
        self.messages = messages
    }
    
    func mostRecentMessage() -> Message? {
        return messages.last
    }
}
    

