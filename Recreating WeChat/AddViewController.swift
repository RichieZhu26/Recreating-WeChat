//
//  AddViewController.swift
//  Recreating WeChat
//
//  Created by myl142857 on 8/22/19.
//  Copyright © 2019 myl142857. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var searchBar: UISearchBar!
    var dismissButton: UIButton!
    var searchTableView: UITableView!
    var tap: UITapGestureRecognizer!
    
    let searchBarHeight: CGFloat = 50
    let dismissButtonWidth: CGFloat = 72
    let cellHeight: CGFloat = 70
    let reuseIdentifier = "searchCellReuse"
    let padding: CGFloat = 4
    var results = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.endEditing(true)
        view.addSubview(searchBar)
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.addTarget(self, action: #selector(selfDismiss), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        searchTableView = UITableView(frame: .zero)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        searchTableView.rowHeight = cellHeight
        searchTableView.tableFooterView = UIView()
        view.addSubview(searchTableView)
        
//        tap = UITapGestureRecognizer(target: self, action: #selector(selfDismiss))
//        view.addGestureRecognizer(tap)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -dismissButtonWidth - (2 * padding)),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarHeight)
            ])
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: padding),
            dismissButton.widthAnchor.constraint(equalToConstant: dismissButtonWidth),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarHeight)
            ])
        
        NSLayoutConstraint.activate([
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    // UITableView DataSource methods
    // 1. cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchTableViewCell
        let result = results[indexPath.row]
        cell.configure(for: result)
        cell.setNeedsUpdateConstraints()
        cell.selectionStyle = .none
        return cell
    }
    
    // 2. numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    // UITableView Delegate methods
    // 1. heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 2. didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        
        let controlTabBarController = self.presentingViewController as? UITabBarController
        let navigationViewController = controlTabBarController?.viewControllers![1] as! UINavigationController
        let contactViewController = navigationViewController.viewControllers.first as! ContactViewController
        cell.delegate = contactViewController as! SearchTableViewCellDelegate
        if let text = cell.nameLabel.text {
            cell.delegate?.searchTableViewCellDidAdd(result: text)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selfDismiss() {
        if self.results == [] {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func update(with results: [String]) {
        self.results = results
        searchTableView.reloadData()
    }
    
    func search(with input: String) {
        DatabaseManager.findUsers(input: input) { users in
            DispatchQueue.main.async {
                self.update(with: users)
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
}

extension AddViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        search(with: text)
    }
}

