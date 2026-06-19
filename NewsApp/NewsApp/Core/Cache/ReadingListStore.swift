//
//  ReadingListStore.swift
//  NewsApp
//
//  Created by Eyüphan Akkaya on 19.06.2026.
//

public protocol ReadingListStore {
    func insert(_ item: NewsModel) async throws
    func delete(_ itemID: String) async throws
    func retrieve() async throws -> [NewsModel]
}
