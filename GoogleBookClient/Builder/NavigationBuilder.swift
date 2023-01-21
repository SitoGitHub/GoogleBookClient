//
//  NavigationBuilder.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 19/1/23.
//

import UIKit
// MARK: - typealias NavigationFactory
typealias NavigationFactory = (UIViewController) -> (UINavigationController)
// MARK: - class NavigationBuilder
final class NavigationBuilder {
    static func build(rootView: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootView)
        return navigationController
    }
}
