//
//  NSURLSessionConfiguration.swift
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation

let changeDefaultSessionConfiguration: Void = {
    if let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self,
                                                              #selector(getter: URLSessionConfiguration.default)),
       let mockDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self,
                                                                  #selector(URLSessionConfiguration
                                                                                .swizzledDefaultSessionConfiguration)) {
        method_exchangeImplementations(defaultSessionConfiguration, mockDefaultSessionConfiguration)
    }
    if let ephemeralSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self,
                                                                #selector(getter: URLSessionConfiguration.ephemeral)),
       let mockEphemeralSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self,
                                                                    #selector(URLSessionConfiguration
                                                                                .swizzledEphemeralSessionConfiguration)) { // swiftlint:disable:this line_length
        method_exchangeImplementations(ephemeralSessionConfiguration, mockEphemeralSessionConfiguration)
    }
}()

extension URLSessionConfiguration {
    /// Swizzles NSURLSessionConfiguration's default and ephermeral sessions to add Mock
    @objc public class func swizzleDefaultSessionConfiguration() {
        _ = changeDefaultSessionConfiguration
    }

    @objc class func swizzledDefaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = swizzledDefaultSessionConfiguration()
        if let protocolClasses = configuration.protocolClasses {
            configuration.protocolClasses = [MockingProtocol.self] as [AnyClass] + protocolClasses
        }
        return configuration
    }

    @objc class func swizzledEphemeralSessionConfiguration() -> URLSessionConfiguration {
        let configuration = swizzledEphemeralSessionConfiguration()
        if let protocolClasses = configuration.protocolClasses {
            configuration.protocolClasses = [MockingProtocol.self] as [AnyClass] + protocolClasses
        }
        return configuration
    }
}
