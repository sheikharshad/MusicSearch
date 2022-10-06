//
//  SearchPaging.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//
import Foundation

extension SearchResponseModel: PageContentType {
    var content: [AlbumListModel] {
        results?.albumMatches?.album?.map({
            AlbumListModel(artist: $0.artist,
                           canStream: $0.canStream,
                           name: $0.name,
                           link: $0.link,
                           thumbImage: $0.thumbImage,
                           album: $0.album,
                           mbID: $0.mbid)
        }) ?? []
    }
}

struct SearchPageRequest: PageRequestable {

    typealias ContentType = SearchResponseModel
    let keyword: String
    private let cancelBag = CancelBag()
    let repo: SearchRepositoryType
    private let logger = Logger(.custom("Paging"))

    func page(number: Int,
              contentCount: Int,
              onCompletion: @escaping (Bool, SearchResponseModel?) -> Void) {
        repo.search(keyword: keyword, pageNo: number, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let err):
                    self.logger.log(type: .failure,
                                    err.errorDescription)
                    onCompletion(false, nil)
                case .finished:
                    break
                }
            }, receiveValue: { model in
                onCompletion(true, model)
            }).store(in: self.cancelBag)
    }
}
