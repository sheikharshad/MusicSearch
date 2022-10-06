//
//  Combine+Helper.swift
//  WeatherViper
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {

    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
