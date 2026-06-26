//
//  HomeViewModelTests+Load.swift
//  NewsTests
//
//  Created by Eyüphan Akkaya on 26.06.2026.
//

import XCTest
import NewsApp


extension HomeViewModelTests {
    func test_load_transitionsThroughLoadingToLoaded() async {
        let (sut, _) = makeSUT()
    
        await expect(sut, states: [.loading, .loaded]) {
            await sut.load()
        }
        
    }
    
    func test_load_transitionsThroughLoadingToNetworkError() async {
        let (sut, client) = makeSUT()
        client.stubbedError = anyNSError()
        
        await expect(sut, states: [.loading, .failed(.network)]) {
            await sut.load()
        }
    }
    
    func test_load_deliversCorrectItemCount_onSuccess() async {
        let (sut, client) = makeSUT()
        client.stubbedResult = [
            uniqueItem(),
            uniqueItem(),
            uniqueItem()
        ]
        
        await sut.load()
        
        XCTAssertEqual(sut.numberOfItems(), 3)
    }
    
    func test_load_deliversCorrectItemCount_onError() async {
        let (sut, client) = makeSUT()
        client.stubbedError = anyNSError()
        
        await sut.load()
        
        XCTAssertEqual(sut.numberOfItems(), 0)
    }
}
