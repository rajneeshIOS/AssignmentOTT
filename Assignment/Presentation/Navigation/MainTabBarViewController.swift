//
//  MainTabBarViewController.swift
//  Assignment
//
//  Created by Rajneesh Singh on 19/10/26.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
     func setupTabBar() {
         let container = AppDependencyContainer()
        let homeVC = UINavigationController(
            rootViewController: container.makeHomeViewController()
        )
        

        let downloadsVC = UINavigationController(
            rootViewController: UIViewController()
        )
        
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        downloadsVC.tabBarItem = UITabBarItem(
            title: "Downloads",
            image: UIImage(systemName: "arrow.down.circle"),
            tag: 2
        )

        
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .gray
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        viewControllers = [
            homeVC,
            downloadsVC,
        ]
    }
}
class AppDependencyContainer {

    func makeHomeViewController() -> HomeViewController {
        let dataSource = LocalJSONDataSource()
        let repository = DLContentRepositoryImpl(dataSource: dataSource)
        let useCase = FetchHomeContentUseCase(repository: repository)
        let viewModel = HomeViewModel(fetchHomeContentUseCase: useCase)

        return HomeViewController(viewModel: viewModel)
    }
}
