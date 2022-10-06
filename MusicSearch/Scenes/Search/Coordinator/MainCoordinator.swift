//
//  MainCoordinator.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//
import UIKit

final class MainCoordinator: NSObject, Coordinator {

    var children: [Coordinator] = []

    var navigationController: UINavigationController
    private lazy var navListener = NavigationPopListener(self.navigationController)
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let albumSearch = AlbumSearchViewController.newInstance()
        albumSearch.coordinator = self
        navListener.add(closure: { [weak self] in
            self?.childDidFinish($0)
        })
        navigationController.pushViewController(albumSearch, animated: false)
    }

    func showDetail(name: String?, artist: String?, mbid: String?) {
        let childCoordinator = DetailCoordinator(navigationController: navigationController,
                                                 param: DetailParameter(album: name,
                                                                        mbID: mbid,
                                                                        artist: artist)
        )
        children.append(childCoordinator)
        childCoordinator.start()
    }

}

protocol NavListenerType {
    func add(closure: @escaping GenericInClosure<Coordinator>)
}

final class NavigationPopListener: NSObject, UINavigationControllerDelegate, NavListenerType {

    private var callBack: GenericInClosure<Coordinator>?

    convenience init(_ navigationController: UINavigationController) {
        self.init()
        navigationController.delegate = self
    }

    func add(closure: @escaping GenericInClosure<Coordinator>) {
        self.callBack = closure
    }

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller.
        // If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller,
        if let coordinated = fromViewController as? CoordinatorFetchable,
           let coordinator = coordinated.getCoordinator() {
            Logger(.search).log("Popped:-\(fromViewController)")
            callBack?(coordinator)
        }
    }

}
