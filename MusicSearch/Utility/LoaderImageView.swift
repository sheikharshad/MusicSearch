//
//  LoaderImageView.swift
//  MarketPlace
//
//  Created by Arshad shaikh on 05/10/2022.
//
import Combine
import UIKit

@objc final class LoaderImageView: UIImageView {

    var cancellable = Set<AnyCancellable>()
    let loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        return view
    }()

    private let ratio = CGFloat(0.4)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = self.frame
        let centre = frame.size.width * CGFloat(0.5)
        let size = frame.size.width * ratio
        let offset = size * 0.5
        loader.frame = .init(x: centre - offset,
                             y: centre - offset,
                             width: size,
                             height: size)
    }

    private func setupUI() {
        addSubview(loader)
    }

    private func onStart() {
        loader.isHidden = false
        loader.startAnimating()
    }

    private func onComplete() {
        loader.isHidden = true
        loader.stopAnimating()
    }
}
