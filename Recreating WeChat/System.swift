//
//  System.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/13/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import Foundation

class System {
    static var chats = [Chat]()
    static var currentUser: String?
    
    static func isNew(user: String) -> Bool {
        if currentUser! == user {return false}
        return false
        //return !chats.contains{chat in chat.friend == user}
    }
}
