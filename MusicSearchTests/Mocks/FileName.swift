//
//  MockFiles.swift
//  MusicSearchTests
//
//  Created by Arshad shaikh on 05/10/2022.
//

enum FileName {
    case custom(_ value: String)
    case mockSearch
    case mockDetail
    var value: String {
        switch self {
        case .custom(let value):
            return value
        case .mockSearch:
            return "mock_search"
        case .mockDetail:
            return "mock_detail"
        }
    }
}
