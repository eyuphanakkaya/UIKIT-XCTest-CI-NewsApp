//
//  HomeViewModelTests+ToggleBookmark.swift
//  NewsTests
//
//  Created by Eyüphan Akkaya on 26.06.2026.
//

import XCTest
import NewsApp


extension HomeViewModelTests {
    func test_toggleBookmark_addsItemToReadingList_whenNotBookmarked() async {
        let (sut, client) = makeSUT()
        let item = uniqueItem(id: "1")
        client.stubbedResult = [ item ]
        
        await sut.load()
        await sut.toggleBookmark(at: 0)
        
        XCTAssertEqual(sut.readingList.first?.id, item.id)
    }
    
    func test_toggleBookmark_removesItemFromReadingList_whenBookmarked() async {
        let (sut, client) = makeSUT()
        let item = uniqueItem(id: "1")
        client.stubbedResult = [ item ]
        
        await sut.load()
        await sut.toggleBookmark(at: 0)
        await sut.toggleBookmark(at: 0)
        
        XCTAssertTrue(sut.readingList.isEmpty)
    }
}
