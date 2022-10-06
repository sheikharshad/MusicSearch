//
//  StoryBoard+Helper.swift
//  WeatherViper
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit

protocol StoryBoardInitializable {
    static var appStoryBoardIdentifier: UIStoryboard.Storyboard { get }
}

extension StoryBoardInitializable where Self: UIViewController {

    static func newInstance() -> Self {
        UIStoryboard.init(storyboard: appStoryBoardIdentifier).instantiateViewController()
    }

    static var appStoryBoardIdentifier: UIStoryboard.Storyboard { .main }
}

extension UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {

    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    // MARK: - View Controller Instantiation from Generics
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
}

extension UIStoryboard {

    /// The uniform place where we state all the storyboard we have in our application

    enum Storyboard: String {
        case main = "Main"
        case listNearestStops = "ListNearestStops"
        case stationDetail = "StationDetail"
        case facility = "Facility"
    }
}

extension UIStoryboard.Storyboard {

    var filename: String {
        return rawValue
    }
}
