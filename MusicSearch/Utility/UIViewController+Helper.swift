//
//  UIViewController+Helper.swift
//  DailyRail
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

extension UIViewController {

    func embeddedInNavigationController(_ nvc: UINavigationController) -> Self {
        Self.embedInNavigationController(vwc: self)
    }

    static func embedInNavigationController<T: UIViewController>(vwc view: T) -> T {
        let navController = UINavigationController(rootViewController: view)
        navController.modalPresentationStyle = .fullScreen
        return view
    }

}
