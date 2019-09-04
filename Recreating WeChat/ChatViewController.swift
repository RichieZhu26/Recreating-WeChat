//
//  ChatViewController.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/9/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
//    var searchBar: UISearchBar!
    var timer: Timer!
    let reuseIdentifier = "chatCellReuse"
    var chats: [Chat]!
    
    let cellHeight: CGFloat = 72
//    let searchBarHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Chats"
        chats = []
        
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
//        searchBar = UISearchBar()
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateChatTableView), userInfo: nil, repeats: true)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        // Setup the constraints for our views
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
//        NSLayoutConstraint.activate([
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarHeight)
//            ])
    }
    
    // UITableView DataSource methods
    
    // 1. cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatTableViewCell
        let chat = chats[indexPath.row]
        cell.configure(for: chat)
        cell.setNeedsUpdateConstraints()
        cell.selectionStyle = .none
        return cell
    }
    
    // 2. numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    // UITableView Delegate methods
    // 1. heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 2. didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChatTableViewCell
        let messageViewController = MessageViewController()
        let chat = chats[indexPath.row]
        messageViewController.title = chat.friend
        navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    @objc func updateChatTableView() {
        DatabaseManager.updateChatTableView() { myfriends in
            let presentFriends = self.reverseArray(array: myfriends)
            self.renewChats(chats: presentFriends)
        }
    }
    
    func reverseArray(array: [[String: String]]) -> [[String: String]] {
        var newArray: [[String: String]] = []
        if array.count > 0 {
            for i in 0 ..< array.count {
                newArray.append(array[array.count - i - 1])
            }
        }
        return newArray
    }
    
    func updateRecentMessage(chatId: String, chatObject: Chat, completion: @escaping (Bool) -> Void) {
        DatabaseManager.getRecentMessage(chatId: chatId) { recentMessage in
            chatObject.recentMessage = recentMessage
            if chatObject.recentMessage == recentMessage {
                completion(true)
            }
            completion(false)
        }
    }
    
    func renewChats(chats: [[String: String]]) {
        var friend = ""
        var id = ""
        self.chats = []
        for i in 0 ..< chats.count {
            for (key, chatId) in chats[i] {
                friend = key
                id = chatId
            }
            let chatGenerator = Chat(id: id, friend: friend, recentMessage: "Not modified")
            updateRecentMessage(chatId: id, chatObject: chatGenerator) { success in
                self.tableView.reloadData()
            }
            self.chats.append(chatGenerator)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
