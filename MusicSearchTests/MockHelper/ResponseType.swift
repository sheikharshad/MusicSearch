//
//  ResponseType.swift
//  CarrefourTests
//
//  Created by Arshad shaikh on 05/10/2022.

import Foundation

enum Download: Equatable {

    // Simulate download in one step
    case content(Data)

    // Simulate download as byte stream
    case streamContent(data: Data, inChunksOf: Int)

    // Simulate empty download
    case noContent
}

func == (lhs: Download, rhs: Download) -> Bool {
    switch(lhs, rhs) {
    case let (.content(lhsData), .content(rhsData)):
        return (lhsData == rhsData)
    case let (.streamContent(data: lhsData, inChunksOf: lhsBytes), .streamContent(data: rhsData, inChunksOf: rhsBytes)):
        return (lhsData == rhsData) && lhsBytes == rhsBytes
    case (.noContent, .noContent):
        return true
    default:
        return false
    }
}

enum Response: Equatable {
    case success(URLResponse, Download)
    case failure(NSError)
}

func == (lhs: Response, rhs: Response) -> Bool {
    switch (lhs, rhs) {
    case let (.failure(lhsError), .failure(rhsError)):
        return lhsError == rhsError
    case let (.success(lhsResponse, lhsDownload), .success(rhsResponse, rhsDownload)):
        return lhsResponse == rhsResponse && lhsDownload == rhsDownload
    default:
        return false
    }
}
