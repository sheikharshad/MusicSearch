//
//  AppAPICall.swift
//  WeatherViper
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Combine
import Foundation

enum APIVersion: String {
    case ver2 = "2.0"
}

protocol AudioScrobblerAPIType: APIBuilder {
    var version: APIVersion { get }
}

extension AudioScrobblerAPIType {
    var query: [String: String] { [String: String]()}
    var baseURL: String {
        guard let url = AppSettings().getValueAsString(key: .audioScrobblerBaseURL) else {
            fatalError("base url is null")
        }
        return url
    }
    func body() throws -> Data? {
        nil
    }
    var method: HttpMethod { .get }
    var path: String { version.rawValue }
    var subPath: String? { nil }
    var format: String { "json" }
}

private extension String {

    enum QKeys: String {

        case method
        case apiKey = "api_key"
        case format
        case artist
        case album
        case mbid
        case autocorrect
        case username
        case lang
        case page
        case limit
    }
}

enum AudioScrobblerAPI: AudioScrobblerAPIType {

    var version: APIVersion { .ver2 }

    enum Method: String {
        case search = "album.search"
        case info = "album.getinfo"
    }

    case search(album: String,
                page: Int,
                limit: Int)
    case info(artist: String? = nil,
              album: String? = nil,
              mbid: String? = nil,
              username: String? = nil,
              autocorrect: Bool? = nil,
              lang: String? = nil)

    var query: [String: String] {
        guard let key = AppSettings().getValueAsString(key: .scrobblerToken) else {
            fatalError("empty token")
        }
        var dictionary = [String: String]()
        dictionary[.QKeys.apiKey.rawValue] = key
        dictionary[.QKeys.format.rawValue] = format
        switch self {
        case .search(let album,
                     let page,
                     let limit):
            dictionary[.QKeys.method.rawValue] = Method.search.rawValue
            dictionary[.QKeys.album.rawValue] = album
            dictionary[.QKeys.page.rawValue] = "\(page)"
            dictionary[.QKeys.limit.rawValue] = "\(limit)"
        case .info(let artist,
                   let album,
                   let mbid,
                   let username,
                   let autocorrect,
                   let lang):
            dictionary[.QKeys.method.rawValue] = Method.info.rawValue
            if let artist = artist {
                dictionary[.QKeys.artist.rawValue] = artist
            }
            if let album = album {
                dictionary[.QKeys.album.rawValue] = album
            }
            if let mbid = mbid {
                dictionary[.QKeys.mbid.rawValue] = mbid
            }
            if let username = username {
                dictionary[.QKeys.username.rawValue] = username
            }
            if let autocorrect = autocorrect {
                dictionary[.QKeys.autocorrect.rawValue] = autocorrect ? "1": "0"
            }
            if let lang = lang {
                dictionary[.QKeys.lang.rawValue] = lang
            }
        }
        return dictionary
    }
}
