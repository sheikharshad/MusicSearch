//
//  Logger.swift
//  DailyRail
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation
import os.log

protocol LoggingSystemType {
    func log(text: String)
}

struct ConsoleLogger: LoggingSystemType {

    func log(text: String) {
        print(text)
    }
}

final class Logger {

    struct Attributes: OptionSet {
        let rawValue: Int
        static let funcName = Attributes(rawValue: 1 << 0)
        static let prefix = Attributes(rawValue: 1 << 1)
        static let flag = Attributes(rawValue: 1 << 3)
        static let status = Attributes(rawValue: 1 << 4)
        static let common: Attributes = [.flag, .prefix, .status]
        static let commonWithdate: Attributes = [.flag, .prefix, .status]
    }
    private let loggingSystem: LoggingSystemType
    private let prefixWord: String
    private let attributes: Attributes
    private let isDebug = !Environment.isProduction
    init(_ word: LoggerType = .custom("##"),
         attributes: Attributes = [.flag, .prefix, .status],
         loggingSystem: LoggingSystemType = ConsoleLogger()) {
        prefixWord = word.value
        self.attributes = attributes
        self.loggingSystem = loggingSystem
    }
    enum Status: String {
        case none
        case success
        case failure
        case warning
        case cancelled
        case info
        var value: String {
            switch self {
            case .none:
                return ""
            case .success:
                return "success"
            case .failure:
                return "failure"
            default:
                return ""
            }
        }

        var flag: String {
            switch self {
            case .success: return "📗"
            case .failure: return "📕"
            case .cancelled: return "📓"
            case .warning: return "📙"
            case .info : return "📘"
            case .none : return ""
            }
        }
    }

    func log(type: Status = .none, _ input: Any?, forcedAttributes: Attributes? = nil, funcname: String = #function) {
        guard isDebug else {
            return
        }
        var prefix = [String]()
        let attributes = forcedAttributes ?? self.attributes
        if attributes.contains(.prefix) {
            prefix.append(prefixWord)
        }
        if attributes.contains(.flag) {
            prefix.append(type.flag)
        }
        if attributes.contains(.status) {
            prefix.append(type.value)
        }
        if attributes.contains(.funcName) {
            prefix.append("\(funcname)")
        }
        prefix.append("\(input ?? "") )")
        loggingSystem.log(text: prefix.joined(separator: "-") )
    }
}

enum LoggerType {

    case network
    case custom(_ prefix: String)
    case search
    case detail

    var value: String {
        switch self {
        case .network:
            return "Network"
        case .search:
            return "Search"
        case .detail:
            return "Detail"
        case .custom(let prefix):
            return prefix
        }
    }
}
