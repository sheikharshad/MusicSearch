//
//  UIResponder+Helper.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

protocol UIIdentifiable {}

extension UIIdentifiable {

    static var identifier: String {
        return "\(self)"
    }
}

extension UIResponder: UIIdentifiable {}
