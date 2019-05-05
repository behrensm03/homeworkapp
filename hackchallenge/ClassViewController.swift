//
//  ClassViewController.swift
//  homeworkapp
//
//  Created by Michael Behrens on 4/23/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController {
    
    var viewTitle: String!
    var searchBar: UISearchBar!
    
    var groupsTableView: UITableView!
    var classForView: Class!
    var originalGroups: [Assignment] = []
    var displayedGroups: [Assignment] = []
    
    let refreshControl = UIRefreshControl()
    let reuse = "assignmentReuse"
    
    init(relatedClass: Class) {
        classForView = relatedClass
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Groups - \(classForView.getTitle())"
        view.backgroundColor = .white
        //let mainColor: UIColor = UIColor(red: 193/255, green: 94/255, blue: 178/255, alpha: 1.0)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        updateGroups()
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        groupsTableView = UITableView()
        groupsTableView.translatesAutoresizingMaskIntoConstraints = false
        groupsTableView.register(GroupTableViewCell.self, forCellReuseIdentifier: reuse)
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.refreshControl = refreshControl
        view.addSubview(groupsTableView)
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.autocorrectionType = .no
        view.addSubview(searchBar)
        searchBar.placeholder = "Find a group in " + classForView.getTitle()
        searchBar.delegate = self
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            groupsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            groupsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            groupsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            groupsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
    }
    
    func updateGroups() {
        NetworkManager.getAssignmentsFromClass(classId: classForView.id,
                                               completion: { assignments in
                                                self.displayedGroups = assignments
                                                self.originalGroups = self.displayedGroups
                                                self.groupsTableView.reloadData()
        })
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.async {
            self.groupsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func addGroup() {
        let addGroupViewController = AddGroupViewController(relatedClass: classForView)
        navigationController?.pushViewController(addGroupViewController, animated: true)
    }
}

extension ClassViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse, for: indexPath) as! GroupTableViewCell
        let group = displayedGroups[indexPath.row]
        cell.configure(for: group)
        return cell
    }
    
}

extension ClassViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignment = displayedGroups[indexPath.row]
        let messagesViewController = MessagesViewController()
        messagesViewController.delegate = self
        messagesViewController.addAssignmentInfo(assignment: assignment)
        navigationController?.pushViewController(messagesViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ClassViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayedGroups.removeAll()
        if searchBar.text == ""{
            for group in originalGroups {
                displayedGroups.append(group)
            }
        }
        else {
            for group in originalGroups {
                //if course.subjectnumber.contains(searchText.uppercased()) {
                if group.name.lowercased().contains(searchText.lowercased()) {
                    displayedGroups.append(group)
                }
            }
        }
        groupsTableView.reloadData()
    }
}
