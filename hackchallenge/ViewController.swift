//
//  ViewController.swift
//  homeworkapp
//
//  Created by Michael Behrens on 4/23/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var browseButton: UIButton!
    var recentLabel: UILabel!
    var recentGroupsCollectionView: UICollectionView!
    var recentClassesCollectionView: UICollectionView!
    var reuse: String = "GroupReuse"
    var reuseClass: String = "ClassReuse"
    var initialRecentGroups: [Group]!
    var recentClassesLabel: UILabel!
    var initialRecentClasses: [Class]!
    var tabController: UITabBarController!
    let browseViewController = BrowseViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Home"
        let mainColor: UIColor = UIColor(red: 193/255, green: 94/255, blue: 178/255, alpha: 1.0)
        view.backgroundColor = .white
        self.navigationController!.navigationBar.barTintColor = mainColor
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        recentLabel = UILabel()
        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        recentLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        recentLabel.textColor = mainColor
        recentLabel.text = "Recent Groups"
        view.addSubview(recentLabel)
        
        recentClassesLabel = UILabel()
        recentClassesLabel.translatesAutoresizingMaskIntoConstraints = false
        recentClassesLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        recentClassesLabel.textColor = mainColor
        recentClassesLabel.text = "Recent Classes"
        view.addSubview(recentClassesLabel)
        
        let recentGroupsLayout = UICollectionViewFlowLayout()
        recentGroupsLayout.scrollDirection = .horizontal
        recentGroupsLayout.minimumLineSpacing = 10
        recentGroupsLayout.minimumInteritemSpacing = 10
        
        recentGroupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recentGroupsLayout)
        recentGroupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentGroupsCollectionView.backgroundColor = .white
        recentGroupsCollectionView.dataSource = self
        recentGroupsCollectionView.delegate = self
        recentGroupsCollectionView.register(RecentGroupCollectionViewCell.self, forCellWithReuseIdentifier: reuse)
        recentGroupsCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(recentGroupsCollectionView)
        
        let recentClassesLayout = UICollectionViewFlowLayout()
        recentClassesLayout.scrollDirection = .horizontal
        recentClassesLayout.minimumLineSpacing = 10
        recentClassesLayout.minimumInteritemSpacing = 10
        
        recentClassesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recentClassesLayout)
        recentClassesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentClassesCollectionView.backgroundColor = .white
        recentClassesCollectionView.dataSource = self
        recentClassesCollectionView.delegate = self
        recentClassesCollectionView.register(RecentGroupCollectionViewCell.self, forCellWithReuseIdentifier: reuseClass)
        recentClassesCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(recentClassesCollectionView)
        
        
        
        let cs3410 = Class(id: 0, subject: "CS", number: 3410, name: "Computer System Organization and Programming")
        let cs2300 = Class(id: 1, subject: "CS", number: 2300, name: "Intermediate Web Design and Programming")
        let orie3120 = Class(id: 2, subject: "ORIE", number: 3120, name: "Practical Tools for OR and Machine Learning")
        let math2930 = Class(id: 3, subject: "MATH", number: 2930, name: "Differential Equations")
        let music1312 = Class(id: 4, subject: "MUSIC", number: 1312, name: "History of Rock Music")
        let hadm1111 = Class(id: 5, subject: "HADM", number: 1111, name: "Hotel Class")
        let ilr2100 = Class(id: 6, subject: "ILR", number: 2100, name: "Labor Relations")
        let bio1000 = Class(id: 7, subject: "BIO", number: 1111, name: "Bio 1")
        let group1 = Group(relatedClass: cs3410, name: "Project 1")
        let group2 = Group(relatedClass: cs2300, name: "Project 4")
        let group3 = Group(relatedClass: orie3120, name: "Prelim 2")
        let group4 = Group(relatedClass: orie3120, name: "Problem Set 4")
        let group5 = Group(relatedClass: math2930, name: "Problem Set 8")
        let group6 = Group(relatedClass: music1312, name: "Final Essay")
        let group7 = Group(relatedClass: cs3410, name: "Project 5")
        let group8 = Group(relatedClass: cs3410, name: "Prelim 2")
        let group9 = Group(relatedClass: cs2300, name: "Lab 10")
        let group10 = Group(relatedClass: hadm1111, name: "Assignment 1")
        let group11 = Group(relatedClass: ilr2100, name: "Prelim 1")
        let group12 = Group(relatedClass: bio1000, name: "Prelim1")
        
        initialRecentGroups = [group1, group2, group3, group4, group5, group6, group7, group8, group9, group10, group11, group12]
        initialRecentClasses = [cs2300, cs3410, orie3120, math2930, ilr2100]
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            recentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            recentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            recentGroupsCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 25),
            recentGroupsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            recentGroupsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            //            recentGroupsCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
            recentGroupsCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
            ])
        
        NSLayoutConstraint.activate([
            recentClassesLabel.topAnchor.constraint(equalTo: recentGroupsCollectionView.bottomAnchor, constant: 25),
            recentClassesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            recentClassesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentClassesLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            recentClassesCollectionView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            recentClassesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            recentClassesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            recentClassesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    @objc func presentBrowseViewController() {
        navigationController?.pushViewController(browseViewController, animated: true)
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recentGroupsCollectionView {
            return initialRecentGroups.count
        }
        else {
            return initialRecentClasses.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recentGroupsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as! RecentGroupCollectionViewCell
            let group = initialRecentGroups[indexPath.item]
            cell.configure(for: group)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseClass, for: indexPath) as! RecentGroupCollectionViewCell
            let course = initialRecentClasses[indexPath.item]
            cell.configure(for: course)
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.recentGroupsCollectionView {
            let cell = initialRecentGroups[indexPath.item]
            let groupViewController = GroupViewController()
            groupViewController.title = cell.relatedClass.getTitle() + " - " + cell.name
            navigationController?.pushViewController(groupViewController, animated: true)
        }
        else {
            let cell = initialRecentClasses[indexPath.item]
            let classViewController = ClassViewController(relatedClass: cell)
            classViewController.title = "Groups - " + cell.getTitle()
            navigationController?.pushViewController(classViewController, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var length = collectionView.frame.height - 60
        if collectionView == self.recentGroupsCollectionView {
            length = length / 2
        }
        return CGSize(width: length, height: length)
    }
}
