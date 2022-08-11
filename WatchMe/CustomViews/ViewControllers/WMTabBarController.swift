//
//  WMTabBarController.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class WMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
        configureNavigationBar()
        viewControllers = [createMoviesNC(), createShowsNC(), createSearchNC(), createFavoriteNC()]
    }
    
    private func createMoviesNC() -> UINavigationController {
        let moviesVC = MoviesVC()
        moviesVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        
        return UINavigationController(rootViewController: moviesVC)
    }
    
    private func createShowsNC() -> UINavigationController {
        let showsVC = ShowsVC()
        showsVC.tabBarItem = UITabBarItem(title: "Shows", image: UIImage(systemName: "tv"), tag: 1)
        
        return UINavigationController(rootViewController: showsVC)
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoriteNC() -> UINavigationController {
        let favoriteVC = FavoriteVC()
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 3)
        
        return UINavigationController(rootViewController: favoriteVC)
    }
    
    private func configureTabBar() {
        UITabBar.appearance().tintColor = .systemRed
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
    }
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemRed
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    }
}
