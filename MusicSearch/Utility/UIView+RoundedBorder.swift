//
//  UIView+RoundedBorder.swift
//  MarketPlace
//
//  Created by Arshad shaikh on 05/10/2022.
//

import UIKit
extension UIView {
    class func fromNib() -> Self? {
        return Bundle(for: Self.self).loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?[0] as? Self
    }
}

struct EdgeInsets {
    // This class is used to make optional edge for constraints
    // can be used like
    // example usage :
    // 1 - EdgeInsets(0,8,8)
    // 2 - EdgeInsets(_,_,8,8)
    let top: CGFloat?
    let left: CGFloat?
    let bottom: CGFloat?
    let right: CGFloat?

    static func all(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(value, value, value, value)
    }

    init(_ top: CGFloat? = nil,
         _ left: CGFloat? = nil,
         _ bottom: CGFloat? = nil,
         _ right: CGFloat? = nil) {
        self.top = top
        self.bottom = bottom
        self.right = right
        self.left = left
    }
    static let zero: EdgeInsets = .all(0)
}

extension UIView {

    func pinEdge(toParent parentView: UIView,
                 edge: EdgeInsets? = .zero,
                 height: CGFloat? = nil,
                 width: CGFloat? = nil ) {
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        var layouts = [NSLayoutConstraint]()
        let parent = parentView
        if let left = edge?.left {
            layouts += [self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: left)]
        }
        if let top = edge?.top {
            layouts += [self.topAnchor.constraint(equalTo: parent.topAnchor, constant: top)]
        }
        if let right = edge?.right {
            layouts += [self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: right)]
        }
        if let bottom = edge?.bottom {
            layouts += [self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottom)]
        }
        if let height = height {
            layouts += [self.heightAnchor.constraint(equalToConstant: height)]
        }
        if let width = width {
            layouts += [self.widthAnchor.constraint(equalToConstant: width)]
        }
        NSLayoutConstraint.activate(layouts)
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
    }
}

extension UIView {
    enum BorderRadius: CGFloat {
        case standard = 5
        case big = 10
    }
    enum BorderThickness: CGFloat {
        case standard = 0.5
        case big = 1
    }
    enum Colors: Int {
        case standard
        case black
        var value: UIColor {
            switch self {
            case .standard: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            case .black: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    func applyBorder(radius: BorderRadius = .standard,
                     thickness: BorderThickness = .standard,
                     color: Colors = .standard ) {
        layer.cornerRadius = radius.rawValue
        layer.borderWidth = thickness.rawValue
        layer.borderColor = color.value.cgColor
    }
}
