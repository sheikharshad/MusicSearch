//
//  URL+Params.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation
extension URL {
    var params: [String: String]? {
        URLComponents(url: self, resolvingAgainstBaseURL: true)?
            .queryItems?.reduce([String: String]()) {
                var prev = $0
                prev[$1.name] = $1.value
                return prev
            }
    }
}
