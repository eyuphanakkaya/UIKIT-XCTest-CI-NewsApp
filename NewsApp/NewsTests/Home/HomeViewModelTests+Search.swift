//
//  HomeViewModelTests+Search.swift
//  NewsTests
//
//  Created by Eyüphan Akkaya on 26.06.2026.
//

import XCTest
import NewsApp

extension HomeViewModelTests {
    func test_search_deliversMatchingItems_onQuery() async {
        let (sut, client) = makeSUT()
        
        await expect(sut, client, query: "Swift") {
            XCTAssertEqual(sut.numberOfItems(), 2)
        }
    }
    
    func test_search_deliversNoItems_onNonMatchingQuery() async {
        let (sut, client) = makeSUT()
        
        await expect(sut, client, query: "Apple") {
            XCTAssertEqual(sut.numberOfItems(), 0)
        }
    }
    
    func test_search_deliversAllItems_onEmptyQueryAfterFiltering() async {
        let (sut, client) = makeSUT()
        client.stubbedResult = [
            uniqueItem(title: "Swift tutorial"),
            uniqueItem(title: "iOS Development"),
            uniqueItem(title: "Swift concurrency")
        ]
        
        await sut.load()
        
        sut.search("Swift")
        sut.search("")
        
        XCTAssertEqual(sut.numberOfItems(), 3)
    }
    
    func test_search_deliversItems_insenstiveToCase() async {
        let (sut, client) = makeSUT()
        
        await expect(sut, client, query: "swift") {
            XCTAssertEqual(sut.numberOfItems(), 2)
        }

    }
    
    private func expect(
        _ sut: HomeViewModel,
        _ client: FeedLoaderSpy,
        query: String,
        assertions: () -> Void
    ) async {
        client.stubbedResult = [
            uniqueItem(title: "Swift tutorial"),
            uniqueItem(title: "iOS Development"),
            uniqueItem(title: "swift concurrency")
        ]
        
        await sut.load()
        
        sut.search(query)
        
        assertions()
    }
}
