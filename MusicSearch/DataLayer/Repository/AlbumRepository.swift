//
//  AlbumRepository.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Combine

protocol AlbumRepositoryType {
    func info(album: String?, artist: String?, mbid: String?) -> AnyPublisher<AlbumResponseModel, APIError>
}

struct AlbumRepository: AlbumRepositoryType, WebService {

    func info(album: String?, artist: String?, mbid: String?) -> AnyPublisher<AlbumResponseModel, APIError> {
        request(from: AudioScrobblerAPI.info(artist: artist, album: album, mbid: mbid))
    }
}
