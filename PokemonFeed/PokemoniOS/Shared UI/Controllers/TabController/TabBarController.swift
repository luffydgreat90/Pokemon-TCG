//
//  TabBarController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 2/2/23.
//

import UIKit

public final class TabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func displayTab(with viewControllers:[UIViewController]){
        self.setViewControllers(viewControllers, animated: true)
    }
}
