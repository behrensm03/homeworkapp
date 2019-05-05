//
//  CustomTabBarController.swift
//  hackchallenge
//
//  Created by Michael Behrens on 4/25/19.
//  Copyright © 2019 Michael Behrens. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: "home")
        navigationController.title = "Home"
        
        let browseViewController = BrowseViewController()
        let browseNavigationController = UINavigationController(rootViewController: browseViewController)
        browseNavigationController.tabBarItem.image = UIImage(named: "search")
        browseNavigationController.title = "Browse"
        
        viewControllers = [navigationController, browseNavigationController]
    }
}
