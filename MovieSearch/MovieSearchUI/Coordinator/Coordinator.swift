//
//  Coordinator.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit
import SwiftData

class Coordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    private let factory: MovieSearchUIFactoryProtocol
    
    init(navigationController: UINavigationController, factory: MovieSearchUIFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        
        let movieSearchViewController = factory.makeMovieSearchViewController(delegate: self)
        let firstNavController = UINavigationController(rootViewController: movieSearchViewController)

        let favoriteMoviesViewController = factory.makeFavoriteMoviesViewController(delegate: self)
        let secondNavController = UINavigationController(rootViewController: favoriteMoviesViewController)

        firstNavController.tabBarItem = UITabBarItem(title: UIStrings.Navigation.search, image: UIImage(systemName: UIStrings.Icons.magnifyingGlass), tag: 0)
        secondNavController.tabBarItem = UITabBarItem(
            title: UIStrings.Navigation.favorites,
            image: UIImage(systemName: UIStrings.Icons.star),
            selectedImage: UIImage(systemName: UIStrings.Icons.star)
        )
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavController, secondNavController]
        navigationController.viewControllers = [tabBarController]
    }
}

extension Coordinator: CoordinatorDelegate {
    
    func showMovieSearchResultsViewController(with textToSearch: String) {
        let resultsViewController = factory.makeMovieSearchResultViewController(textToSearch: textToSearch, delegate: self)
        navigationController.pushViewController(resultsViewController, animated: true)
    }
    
    func showMovieDetailsViewController(with movieId: Int, updateDelegate: MovieSearchResultViewControllerUpdateDelegate?) {
        let movieDetailsViewController = factory.makeMovieDetailsViewController(movieId: movieId, updateDelegate: updateDelegate)
        navigationController.pushViewController(movieDetailsViewController, animated: true)
    }
}
