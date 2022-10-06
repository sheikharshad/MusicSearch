//
//  SearchRepository.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Combine

protocol SearchRepositoryType {
    func search(keyword: String, pageNo: Int, limit: Int) -> AnyPublisher<SearchResponseModel, APIError>
}

struct SearchRepository: SearchRepositoryType, WebService {

    func search(keyword: String, pageNo: Int, limit: Int = 20) -> AnyPublisher<SearchResponseModel, APIError> {
        request(from: AudioScrobblerAPI.search(album: keyword, page: pageNo, limit: limit))
    }
}
