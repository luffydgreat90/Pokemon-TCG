//
//  TabBarController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 2/2/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayTab(with viewControllers:[UIViewController]){
        self.setViewControllers(viewControllers, animated: true)
    }
}
