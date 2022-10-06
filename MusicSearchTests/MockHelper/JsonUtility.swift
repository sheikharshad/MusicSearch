//
//  JsonUtility.swift
//  DailyRailTests
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation

extension Bundle {
    static let appTestBundle = Bundle(identifier: "com.arshad.MusicSearchTests")!
}

struct JsonFileNameType {

    let fileName: FileName
    let bundle: Bundle

    static func testJson(file: FileName) -> Self {
        JsonFileNameType(fileName: file, bundle: .appTestBundle)
    }
    static func appJson(file: FileName) -> Self {
        JsonFileNameType(fileName: file, bundle: .main)
    }

    var path: String? {
        bundle.path(forResource: fileName.value, ofType: "json")
    }
}

final class JSONUtility {

    func dataFromBundle(file: JsonFileNameType) throws ->  Data? {
        guard let path = file.path else {
            return nil
        }
        return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    func decodeFromJson<T: Decodable>(file: JsonFileNameType, type: T.Type) throws -> T? {
        guard let data = try dataFromBundle(file: file ) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
