//
//  UIimageView+Helper.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {

    var imageUrl: String? {
        get {
            nil
        }
        set {
            guard let value = newValue,
                  let url = URL(string: value) else {
                      return
                  }
            kf.setImage(with: url)
        }

    }

}
