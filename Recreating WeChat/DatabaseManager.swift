//
//  DatabaseManager.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/15/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class DatabaseManager {
    
    static var url: String {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return ""}
        return dict.value(forKey: "DATABASE_URL") as! String
    }
    
    static var ref: DatabaseReference {
        return Database.database().reference(fromURL: url)
    }
    
//    static func getChatInfo(completion: @escaping ([(String, String)]?) -> Void) {
//        ref.child("users/\(System.currentUser!)/chats").observeSingleEvent(of: .value, with: { snapshot in
//            if let infoDict = snapshot.value as? [String: Any] {
//                let info = infoDict.map { (chatId, friend) in (chatId, friend as! String) }
//                completion(info)
//            } else {
//                completion(nil)
//            }
//        }) { error in
//            print(error.localizedDescription)
//            completion(nil)
//        }
//    }
    
//    static func getChats(info: [(String, String)], completion: @escaping (Bool) -> Void) {
//        var success = true
//        let dispatchGroup = DispatchGroup()
//        var chats = [Chat]()
//        info.forEach { (chatId, friend) in
//            dispatchGroup.enter()
//            ref.child("chats/\(chatId)/messages").observeSingleEvent(of: .value, with: { snapshot in
//                print(snapshot)
//                if let messageDict = snapshot.value as? [String: Any] {
//                    var messages = [Message]()
//                    messageDict.forEach { (messageId, messageObject) in
//                        let message = Message.fromDatabase(object: messageObject as! [String: Any])
//                        message.id = messageId
//                        messages.append(message)
//                    }
//                    chats.append(Chat(id: chatId, friend: friend, messages: messages.sorted { $0.timestamp < $1.timestamp }))
//                } else {
//                    chats.append(Chat(id: chatId, friend: friend, messages: []))
//                }
//                dispatchGroup.leave()
//            })
//        }
//        dispatchGroup.notify(queue: .main, execute: {
//            System.chats = chats
//            completion(success)
//        })
//    }
    
    static func findUsers(input: String, completion: @escaping ([String]) -> Void) {
        ref.child("users").queryOrderedByKey().queryStarting(atValue: input).queryEnding(atValue: "\(input)\u{f88f}").observeSingleEvent(of: .value) { snapshot in

            if let usersDict = snapshot.value as? [String: Any] {
                let results = usersDict.map { (user, _) in user }
                completion(results)
                return
            }
            completion([])
        }
    }
    
    static func addFriend(friend: String, completion: @escaping (Bool) -> Void) {
        var tasks = 0

        ref.child("chats").childByAutoId().updateChildValues(["messages": true]) {
            (error, reference) in
            if let _ = error {
                completion(false)
                return
            }
            
            let chatId = reference.key as! String
            
            var yourChats: [String] = []
            // ["rz327: -SKDHFJAKDKCNAHHGKHDK]
            var yourFriends: [[String: String]] = [[:]]
            
            ref.child("users").child(friend).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                yourChats = value?["chats"] as? [String] ?? []
                yourChats.append(chatId)
                let updates = ["users/\(friend)/chats": yourChats] as [String : Any]
                ref.updateChildValues(updates, withCompletionBlock: {(error, _) in
                    if let _ = error {
                        completion(false)
                        return
                    }
                })
            }) { (error) in
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            ref.child("users").child(friend).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                yourFriends = value?["friends"] as? [[String: String]] ?? []
                let newDic = [System.currentUser!: chatId]
                yourFriends.append(newDic)
                let updates = ["users/\(friend)/friends": yourFriends] as [String : Any]
                ref.updateChildValues(updates, withCompletionBlock: {(error, _) in
                    if let _ = error {
                        completion(false)
                        return
                    }
                })
            }) { (error) in
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            var myChats: [String] = []
            var myFriends: [[String: String]] = [[:]]
            
            ref.child("users").child(System.currentUser!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                myChats = value?["chats"] as? [String] ?? []
                myChats.append(chatId)
                let updates = ["users/\(System.currentUser!)/chats": myChats] as [String : Any]
                ref.updateChildValues(updates, withCompletionBlock: {(error, _) in
                    if let _ = error {
                        completion(false)
                        return
                    }
                })
            }) { (error) in
                print(error.localizedDescription)
                completion(false)
            }
            
            ref.child("users").child(System.currentUser!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                myFriends = value?["friends"] as? [[String: String]] ?? []
                let newDic = [friend: chatId]
                myFriends.append(newDic)
                let updates = ["users/\(System.currentUser!)/friends": myFriends] as [String : Any]
                ref.updateChildValues(updates, withCompletionBlock: {(error, _) in
                    if let _ = error {
                        completion(false)
                        return
                    }
                })
            }) { (error) in
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    static func updateChatTableView(completion: @escaping ([[String: String]]) -> Void) {
        ref.child("users").child(System.currentUser!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let myFriends = value?["friends"] as? [[String: String]] ?? []
            completion(myFriends)
        }) { (error) in
            print(error.localizedDescription)
            completion([[:]])
        }
    }
    
    static func getChatId(friend: String, completion: @escaping (String) -> Void) {
        var chatId = ""
        ref.child("users").child(System.currentUser!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let myChats = value?["friends"] as? [[String: String]] ?? []
            for i in myChats{
                for (key, value) in i {
                    if key == friend {
                        chatId = value
                    }
                }
            }
            completion(chatId)
        }) { (error) in
            print(error.localizedDescription)
            completion("")
        }
    }
    
    static func sendMessage(chatId: String, message: Message, completion: @escaping (Bool) -> Void) {
        var list: [String] = []
        ref.child("chats").child(chatId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            list = value?["messages"] as? [String] ?? []
            list.append(message.body)
            let updates = [chatId: list] as [String : Any]
            ref.updateChildValues(updates, withCompletionBlock: {(error, _) in
                if let _ = error {
                    completion(false)
                    return
                }
            })
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
            return
        }
    }
    
    static func updateMessageTableView(chatId: String, completion: @escaping ([Message]) -> Void) {
        ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let currentList = value?[chatId] as? [Message] ?? []
            completion(currentList)
        }) { (error) in
            print(error.localizedDescription)
            completion([])
        }
    }
}
