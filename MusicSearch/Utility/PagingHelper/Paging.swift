//
//  Paging.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

protocol PageRequestable {
    associatedtype ContentType: PageContentType
    func page(number: Int,
              contentCount: Int,
              onCompletion: @escaping (_ isSuccess: Bool, _ result: ContentType?) -> Void)
}

protocol PageContentType {
    associatedtype PageElement
    var content: [PageElement] { get }
}

protocol PageManagable: AnyObject {
    associatedtype ContentType: PageContentType
    var contents: [ContentType.PageElement] { get }
    var isEndOfPage: Bool { get }
    var pageSize: Int { get }
    var currentPageNo: Int { get }
    func startFromBeginning()
    func fetchNext(onCompletion: @escaping(_ isSuccess: Bool, _ result: ContentType?) -> Void)
}

extension PageManagable {
    var hasMorePages: Bool {
        return isEndOfPage == false
    }
}

final class PagingManager<PageRequestType: PageRequestable>: PageManagable {

    typealias ContentType = PageRequestType.ContentType
    private(set)var lastResponse: PageRequestType.ContentType?
    private(set)var contents: [PageRequestType.ContentType.PageElement]
    private var pageRequest: PageRequestType
    private(set)var isEndOfPage: Bool = false
    private(set)var pageSize: Int
    private(set)var currentPageNo: Int
    private let firstPage: Int
    private let lastPage: Int?

    init(pageRequest: PageRequestType,
         firstPage: Int = 0,
         contentCount: Int,
         lastPage: Int? = nil) {
        self.currentPageNo = firstPage
        self.firstPage = firstPage
        self.pageRequest = pageRequest
        self.pageSize = contentCount
        self.lastPage = lastPage
        self.contents = []
    }

    func startFromBeginning() {
        isEndOfPage = false
        currentPageNo = firstPage
        contents = []
    }

    func removeAll() {
        contents.removeAll()
    }

    func fetchNext(onCompletion: @escaping (_ success: Bool, _ data: PageRequestType.ContentType?) -> Void) {

        if !isEndOfPage, let lastPage = lastPage {
            isEndOfPage = currentPageNo > lastPage
        }

        guard !isEndOfPage else {
            onCompletion(false, nil)
            return
        }

        fetch { [weak self] success, result in
            guard let self = self else {
                onCompletion(false, nil)
                return
            }
            guard success,
                   let result = result else {
                       onCompletion(false, nil)
                       return
            }
            self.lastResponse = result
            self.isEndOfPage = self.checkIsEndOfPage(lastReponse: self.lastResponse,
                                                         resultCount: result.content.count,
                                                         pageSize: self.pageSize)
            self.contents.append(contentsOf: result.content)
            self.currentPageNo += 1
            onCompletion(success, result)
        }
    }

    private func fetch( onCompletion: @escaping (_ isSuccess: Bool, _ result: ContentType?) -> Void) {
        guard isEndOfPage == false else {
            onCompletion(false, nil )
            return
        }
        pageRequest.page(number: currentPageNo, contentCount: pageSize) { success, result in
            guard let result = result else {
                onCompletion(false, nil)
                return
            }
            onCompletion(success, result)
        }
    }

    func checkIsEndOfPage(lastReponse: PageRequestType.ContentType?, resultCount: Int, pageSize: Int ) -> Bool {
        // MARK: - This function overridable in case need to change the endOfPage Logic
        return  resultCount < pageSize
    }
}
