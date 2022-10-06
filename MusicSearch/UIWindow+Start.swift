//
//  UIWindow+Helper.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

extension UIWindow {

    private func createNewRootViewController(coordinator: inout MainCoordinator?) -> UIViewController? {
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
        coordinator?.start()
        return navigationController
    }

    static func createWindow(using scene: UIScene) -> UIWindow {
        guard let windowScene = (scene as? UIWindowScene) else {
            fatalError("Window cannot init")
        }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        return window
    }

    static func createWindow() -> UIWindow {
        UIWindow(frame: UIScreen.main.bounds)
    }

    @discardableResult func setupForDisplay(using coordinator: inout MainCoordinator?) -> UIWindow {
        rootViewController = createNewRootViewController(coordinator: &coordinator)
        makeKeyAndVisible()
        return self
    }
}
