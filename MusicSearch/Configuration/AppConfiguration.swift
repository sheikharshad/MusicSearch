//
//  AppConfiguration.swift
//  Market Place
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation

enum Environment {
    case uat
    // swiftlint:disable identifier_name
    case qa
    case prod
    static var isProduction: Bool = {
        let dic = ProcessInfo.processInfo.environment
        if let forceProduction = dic["forceProduction"], forceProduction == "true" {
            return true
        }
#if PROD
        return true
#else
        return false
#endif

    }()

    static var current: Environment {
#if PROD
        return .prod
#elseif QA
        return .qa
#else
        return .uat
#endif
    }
}

protocol AppConfigurable {
    var bundle: Bundle { get }
    var configurationKey: String { get }
    func value<T>(for key: String) throws -> T where T: LosslessStringConvertible
}

enum AppConfigurableError: Swift.Error {
    case missingKey
    case invalidValue
}

extension AppConfigurable {

    var configurationKey: String { "Configuration" }

    func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let configuration = bundle.object(forInfoDictionaryKey: configurationKey) as? [String: Any],
              let object = configuration[key] else {
                  throw AppConfigurableError.missingKey
              }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw AppConfigurableError.invalidValue
        }
    }

    func getValue<T>(for key: Environment.Keys) throws -> T where T: LosslessStringConvertible {
        try value(for: key.rawValue)
    }
}

extension Environment {

    enum Keys: String {
        case audioScrobblerBaseURL = "SCROBBLER_BASE_URL"
        case scrobblerToken = "SCROBBLER_TOKEN"
        case timeZone = "DEFAULT_TIMEZONE"
    }
}

struct AppSettings: AppConfigurable {

    let logger = Logger(.custom("config"))
    var bundle: Bundle = .main

    func getValueAsString(key: Environment.Keys) -> String? {
        do {
            let stringValue: String = try getValue(for: key)
            return stringValue
        } catch {
            logger.log(type: .failure, error.localizedDescription)
            return nil
        }
    }
}
