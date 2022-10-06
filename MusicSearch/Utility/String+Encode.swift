//
//  String+Encode.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

extension String {
    var encoded: String? { addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)}
}
