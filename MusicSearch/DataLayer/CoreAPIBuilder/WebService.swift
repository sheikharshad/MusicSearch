//
//  Service.swift
//  Market Place
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation
import Combine
protocol WebService { }

protocol DecoderType {
    func decode<R: Decodable> (data: Data, for type: R.Type) -> AnyPublisher<R, APIError>
}

extension JSONDecoder: DecoderType {

    func decode<R: Decodable> (data: Data, for type: R.Type) -> AnyPublisher<R, APIError> {
        let jsonDecoder = JSONDecoder()
      //let str = String(decoding: data, as: UTF8.self)
      //print(str)
        return Just(data)
            .decode(type: type, decoder: jsonDecoder)
            .mapError { error in
                APIError.decodingError(message: error.localizedDescription) }
            .eraseToAnyPublisher()
    }
}

extension JSONSerialization: DecoderType {

    func decode<R: Decodable> (data: Data, for type: R.Type) -> AnyPublisher<R, APIError> {
        return Future<R, APIError> { promise in
            do {
                let objects = try JSONSerialization.jsonObject(with: data)
                guard let jsonData = objects as? R else {
                    promise(.failure(APIError.decodingError(message: "Error on Typecast")))
                    return
                }
                promise(.success(jsonData))
            } catch {
                promise(.failure(APIError.decodingError(message: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
}

extension WebService {

    func request<T: APIBuilder, R: Decodable>(from endpoint: T,
                                              decoder: DecoderType = JSONDecoder()) -> AnyPublisher<R, APIError> {
        do {
            let urlRequest = try endpoint.urlRequest()
            return URLSession
                .shared
                .dataTaskPublisher(for: urlRequest)
                .receive(on: DispatchQueue.main)
                .mapError { error in
                    APIError(code: error.errorCode, message: error.localizedDescription)
                }
                .flatMap { data, response -> AnyPublisher<R, APIError> in
                 // print(response)
                    guard let response = response as? HTTPURLResponse else {
                        return Fail(error: APIError.unknown).eraseToAnyPublisher()
                    }
                    if (HTTPCodes.success).contains(response.statusCode) {
                        return decoder.decode(data: data, for: R.self)
                    } else {
                        return Fail(error: APIError(code: response.statusCode)).eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail<R, APIError>(error: .invalidURL).eraseToAnyPublisher()
        }
    }
}
