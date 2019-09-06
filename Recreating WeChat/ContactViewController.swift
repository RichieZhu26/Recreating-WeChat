//
//  ContactViewController.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/9/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit
import Firebase

class ContactViewController: UIViewController {
    
    var addBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Contacts"
        view.backgroundColor = .lightGray
        
        addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(rightTapped(_:)))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc func rightTapped(_ sender: UIBarButtonItem!) {
        let addViewController = AddViewController()
        present(addViewController, animated: true, completion: nil)
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

extension ContactViewController: SearchTableViewCellDelegate {
    
    func searchTableViewCellDidAdd(result: String) {
        DatabaseManager.addFriend(friend: result) { success in
            if success {
                return
            }
        }
    }
}
