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
    var searchBar: UISearchBar!
    var timer: Timer!
    let reuseIdentifier = "chatCellReuse"
    var chats: [Chat]!
    
    let cellHeight: CGFloat = 70
    let searchBarHeight: CGFloat = 50
    
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
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateChatTableView), userInfo: nil, repeats: true)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        // Setup the constraints for our views
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarHeight),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarHeight)
            ])
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
        print("Timer is working")
        DatabaseManager.updateChatTableView() { myfriends in
            print(myfriends.count)
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
    
    func renewChats(chats: [[String: String]]) {
//        print(chats.count)
        var chatGenerator: Chat
        var friend = ""
        self.chats = []
        for i in 0 ..< chats.count {
            for (key, _) in chats[i] {
                friend = key
            }
            chatGenerator = Chat(id: String(i), friend: friend, messages: [])
            self.chats.append(chatGenerator)
        }
        tableView.reloadData()
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
