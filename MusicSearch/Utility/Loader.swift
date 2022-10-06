//
//  Loader.swift
//  MarketPlace
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Combine
import UIKit

final class LoaderView: UIView, LoaderType {

    @IBOutlet private weak var activityView: UIActivityIndicatorView!

    func show() {
        activityView.isHidden = false
        activityView.startAnimating()
    }

    func hide() {
        activityView.isHidden = true
        activityView.stopAnimating()
    }
}

protocol LoaderType {

    func show()
    func hide()
}

struct Loader: LoaderType {

    let view: UIView?
    let loader: (LoaderType & UIView)? = LoaderView.fromNib()
    func show() {
        addToView()
        loader?.show()
    }

    fileprivate func addToView() {
        guard let loader =  loader,
              let view = view else {
                  return
              }
        loader.pinEdge(toParent: view)
    }

    func hide() {
        loader?.removeFromSuperview()
        loader?.hide()
    }
}
