//
//  CoordinatorProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    func start()
}
