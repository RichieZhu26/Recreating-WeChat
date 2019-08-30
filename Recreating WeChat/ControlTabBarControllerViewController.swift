//
//  ControlTabBarControllerViewController.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/9/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

class ControlTabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {

    var chat: UINavigationController!
    var contact: UINavigationController!
    var discover: UINavigationController!
    var me: UINavigationController!
    
    var contactRoot: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chat = UINavigationController(rootViewController: ChatViewController())
        contact = UINavigationController(rootViewController: ContactViewController())
        discover = UINavigationController(rootViewController: DiscoverViewController())
        me = UINavigationController(rootViewController: MeViewController())
        
        // Create Chat
        let chatBarItem = UITabBarItem(title: "Chats", image: nil, selectedImage: nil)
        chat.tabBarItem = chatBarItem
        
        // Create Contact
        let contactBarItem = UITabBarItem(title: "Contacts", image: nil, selectedImage: nil)
        contact.tabBarItem = contactBarItem
        
        // Create Discover
        let discoverBarItem = UITabBarItem(title: "Discover", image: nil, selectedImage: nil)
        discover.tabBarItem = discoverBarItem
        
        // Create Me
        let meBarItem = UITabBarItem(title: "Me", image: nil, selectedImage: nil)
        me.tabBarItem = meBarItem
        
        self.viewControllers = [chat, contact, discover, me]
        
        // Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
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
