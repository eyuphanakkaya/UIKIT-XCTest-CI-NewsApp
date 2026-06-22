//
//  RemoteFeedLoaderTests.swift
//  NewsTests
//
//  Created by Eyüphan Akkaya on 22.06.2026.
//

import XCTest
import NewsApp

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let ( _ , client) = makeSUT()
        
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() async throws {
        let url = URL(string: "https://www.example.com")!
        let (sut, client) = makeSUT(url)
        
        client.results = [.success((validJSON(), anyHTTPURLResponse(for: url)))]
        
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    // MARK: - Helpers
    private func makeSUT(_ url: URL = URL(string: "https://dummy.url")!) -> (sut: FeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(baseURL: url, client: client)
        
        return (sut, client)
    }
    
    
    private final class HTTPClientSpy: HTTPClient {
        private(set) var requestURLs = [URL]()
        var results: [Result<(Data, HTTPURLResponse), Error>] = []
        
        func get(url: URL) async throws -> (Data, HTTPURLResponse) {
            requestURLs.append(url)
            return try results.removeFirst().get()
        }
    }
    
    private func validJSON() -> Data {
        let json: [String: Any] = [
            "results": [],
            "nextPage": NSNull()
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func anyHTTPURLResponse(for url: URL) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
}
