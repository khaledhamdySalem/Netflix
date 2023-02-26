//
//  ViewController.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

class NetflixTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setControllers()
    }
    
    private func setControllers() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpComingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "UpComing"
        vc3.tabBarItem.title = "Search"
        vc4.tabBarItem.title = "Downloads"
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        let controllers = [vc1, vc2, vc3, vc4]
        
        setViewControllers(controllers, animated: true)
        
    }
}

