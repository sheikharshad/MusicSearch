//
//  Alert+Helper.swift
//  DailyRail
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

struct ActionButton {

    let text: String
    let style: UIAlertAction.Style
}

typealias ActionCallBack = (_ index: Int, _ alert: () -> Void?) -> Void

protocol Presentable {
    func show(alertController: UIAlertController,
              animated: Bool,
              completion: (() -> Void)?)
}

protocol AlertType {}

extension AlertType {

    func alert(
        presenter: Presentable,
        title: String,
        message: String,
        buttons: [ActionButton],
        completion: ActionCallBack?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissCallback = { [weak alert] in
                alert?.dismiss(animated: true, completion: nil)
            }
            buttons.enumerated().forEach { (index, element) in
                let action = UIAlertAction(title: element.text,
                                           style: element.style,
                                           handler: { _ in
                    completion?(index, dismissCallback)
                })
                alert.addAction(action)
            }
            presenter.show(alertController: alert, animated: true, completion: nil)
        }
}

extension AlertType where Self: Presentable {

    func alert(title: String,
               message: String,
               buttons: [ActionButton],
               completion: ActionCallBack?) {
        alert(presenter: self,
              title: title,
              message: message,
              buttons: buttons,
              completion: completion)
    }

    func show(errorMessage: String) {
        alert(title: "Error", message: errorMessage, buttons: [.init(text: "Ok", style: .cancel)]) { _, dismiss in
            dismiss()
        }
    }
}

typealias AlertPresentable = AlertType&Presentable

extension UIViewController: AlertPresentable {

    func show(alertController: UIAlertController, animated: Bool, completion: (() -> Void)?) {
        navigationController?.present(alertController, animated: animated, completion: completion)
    }
}
