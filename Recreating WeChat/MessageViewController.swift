//
//  MessageViewController.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/28/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var sendTextField: UITextField!
    var sendButton: UIButton!
    var backBarButtonItem: UIBarButtonItem!
    var tap: UITapGestureRecognizer!
    var timer: Timer!
    
    let reuseIdentifier = "messageCellReuse"
    var messages: [Message]!
    var chatId = ""
    
    let cellHeight: CGFloat = 60
    let textFieldHeight: CGFloat = 60
    let padding: CGFloat = 12
    let buttonWidth: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        messages = []
        
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        sendTextField = UITextField()
        sendTextField.translatesAutoresizingMaskIntoConstraints = false
        sendTextField.backgroundColor = .gray
        sendTextField.borderStyle = .roundedRect
        view.addSubview(sendTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        view.addSubview(sendButton)
        
        backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToChat))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        tap = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(tap)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateMessageTableView), userInfo: nil, repeats: true)
        getChatId(friend: self.title!)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        // Setup the constraints for our views
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendTextField.topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            sendTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonWidth - padding),
            sendTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -textFieldHeight),
            sendTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: sendTextField.trailingAnchor, constant: padding),
            sendButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            sendButton.topAnchor.constraint(equalTo: sendTextField.topAnchor),
            sendButton.bottomAnchor.constraint(equalTo: sendTextField.bottomAnchor)
            ])
    }
    
    // UITableView DataSource methods
    
    // 1. cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.configure(for: message)
        cell.setNeedsUpdateConstraints()
        cell.selectionStyle = .none
        return cell
    }
    
    // 2. numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    // UITableView Delegate methods
    // 1. heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 2. didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y == 0{
            view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y != 0{
            view.frame.origin.y += keyboardFrame.height
        }
    }
    
    @objc func sendMessage() {
        view.endEditing(true)
        let newMessage = Message(sender: System.currentUser!, recipient: self.title!, body: self.sendTextField.text ?? "", hasRead: false, timestamp: 0)
        if self.chatId != "" {
            DatabaseManager.sendMessage(chatId: self.chatId, message: newMessage) { success in
                if success {
                    return
                }
            }
        }
    }
    
    @objc func keyboardDismiss() {
        view.endEditing(true)
    }
    
    func getChatId(friend: String) -> Void {
        DatabaseManager.getChatId(friend: friend) { id in
            self.chatId = id
            }
        }
    
    @objc func updateMessageTableView() {
        if self.chatId != "" {
            DatabaseManager.updateMessageTableView(chatId: self.chatId) { messages in
                self.renewMessages(messages: messages)
            }
        }
    }
    
    func renewMessages(messages: [String]) {
        var messageGenerator: Message
        self.messages = []
        for i in messages {
            let senderEndIndex = i.firstIndex(of: "[")!
            let recipientStartIndex = i.index(after: i.firstIndex(of: "]")!)
            let recipientEndIndex = i.firstIndex(of: ":")!
            let bodyStartIndex = i.index(after: i.firstIndex(of: " ")!)
            let senderRange = i.startIndex..<senderEndIndex
            let recipientRange = recipientStartIndex..<recipientEndIndex
            let bodyRange = bodyStartIndex..<i.endIndex
            messageGenerator = Message(sender: String(i[senderRange]), recipient: String(i[recipientRange]), body: String(i[bodyRange]), hasRead: false, timestamp: 0)
            self.messages.append(messageGenerator)
        }
        tableView.reloadData()
    }
    
    @objc func backToChat() {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
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
