//
//  Coordinator.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

extension Coordinator {
    //remove old ones when user moves back
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() where coordinator === child {
            children.remove(at: index)
            break
        }
    }
}

protocol Coordinatable {

    associatedtype CoordinatorType: Coordinator
    var coordinator: CoordinatorType? { get }
}

protocol CoordinatorFetchable {

    func getCoordinator() -> Coordinator?
}

typealias CoordinatorViewController = Coordinatable & CoordinatorFetchable

extension Coordinatable where Self: CoordinatorFetchable {

    func getCoordinator() -> Coordinator? {
        coordinator
    }
}
