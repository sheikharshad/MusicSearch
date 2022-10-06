//
//  Segue+Helper.swift
//  WeatherViper
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

protocol SegueIdentifiable {

    var identifier: String { get }
}

extension SegueIdentifiable where Self: RawRepresentable, Self.RawValue == String {
    var identifier: String {
        return rawValue
    }
}

extension UIViewController {

    func performSegue(segue: SegueIdentifiable, sender: Any?) {
        performSegue(withIdentifier: segue.identifier, sender: sender)
    }
}
