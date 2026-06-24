//
//  UserDefaultsReadingListStoreTests.swift
//  NewsTests
//
//  Created by Eyüphan Akkaya on 24.06.2026.
//

import XCTest
import NewsApp

final class UserDefaultsReadingListStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyListOnEmptyStore() async throws {
        let sut = makeSUT()
        
        let result = try await sut.retrieve()
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_insert_deliversInsertedItem() async throws {
        let sut = makeSUT()
        let item = uniqueItem()

        
        try await sut.insert(item)
        
        try await expect(sut, toRetrieve: [item])
    }
    
    func test_insert_replacesExistingItemWithSameID() async throws {
        let sut = makeSUT()
        
        let first = uniqueItem(id: "1")
        
        let updated = uniqueItem(id: "1")
        
        try await sut.insert(first)
        try await sut.insert(updated)
        
        try await expect(sut, toRetrieve: [updated])
    }
    
    
    func test_delete_removesInsertedItem() async throws {
        let sut = makeSUT()
        let item = uniqueItem()
        
        try await sut.insert(item)
        
        try await sut.delete(item.id)
        
        let result = try await sut.retrieve()
        
        XCTAssertEqual(result, [])
    }
    
    func test_delete_removesOnlyMatchingItem() async throws {
        let sut = makeSUT()
        let (item1, item2, item3) = (uniqueItem(), uniqueItem(), uniqueItem())
        
        try await sut.insert(item1)
        try await sut.insert(item2)
        try await sut.insert(item3)
        
        try await sut.delete(item2.id)
        
        try await expect(sut, toRetrieve: [item1, item3])
    }
    
    func test_delete_nonExistingItemLeavesStoreUnchanged() async throws {
        let sut = makeSUT()
        let (item1, item2) = (uniqueItem(), uniqueItem())
        
        
        try await sut.insert(item1)
        try await sut.insert(item2)
        
        try await sut.delete("3")
        
        try await expect(sut, toRetrieve: [item1, item2])
    }
    
    
    // MARK: - Helpers
    private func makeSUT() -> UserDefaultsReadingListStore {
         let sut = UserDefaultsReadingListStore(
            userDefaults: UserDefaults(suiteName: UUID().uuidString)!
        )
        return sut
    }
    
    private func expect(_ sut: UserDefaultsReadingListStore,
                        toRetrieve expected: [NewsModel],
                        file: StaticString = #filePath,
                        line: UInt = #line) async throws {
        let result = try await sut.retrieve()
        
        XCTAssertEqual(result, expected, file: file, line: line)
    }
    
    
    private func uniqueItem(
        id: String = UUID().uuidString,
        title: String = "any title"
    ) -> NewsModel {
        NewsModel(
            id: id,
            title: title,
            imageURL: "https://image.com/image.jpg",
            creator: ["John"],
            pubDate: "2026-06-22",
            description: "Description"
        )
    }
}
