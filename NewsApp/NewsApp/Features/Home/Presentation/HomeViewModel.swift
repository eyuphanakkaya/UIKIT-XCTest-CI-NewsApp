//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Eyüphan Akkaya on 16.06.2026.
//

import Foundation

@MainActor
final class HomeViewModel {
    private let loader: FeedLoader
    private let store: ReadingListStore
    
    private(set) var news: [NewsModel] = []
    private var allNews: [NewsModel] = []
    
    private(set) var readingList: [NewsModel] = []
    
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String = ""
    
    var onUpdate: (() -> Void)?
    
    init(loader: FeedLoader, store: ReadingListStore) {
        self.loader = loader
        self.store = store
    }
    
    
    func load() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            allNews = try await loader.load()
            news = allNews
            
            onUpdate?()
        } catch {
            errorMessage = error.localizedDescription
            onUpdate?()
        }
    }
    
    func search(_ query: String) {
        guard !query.isEmpty else {

            news = allNews
            onUpdate?()
            return
        }

        news = allNews.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }

        onUpdate?()
    }
    
}

extension HomeViewModel {
    func fetchReadingList() async {
        do {
            readingList = try await store.retrieve()
        } catch {
            print(error)
        }
    }
    
    func toggleReadingList(_ news: NewsModel) async {
        if readingList.contains(where: { $0.id == news.id }) {
            await removeFromReadingList(news.id)
        } else {
            await addToReadingList(news)

        }
    }
    
    
    private func addToReadingList(_ news: NewsModel) async {
        do {
            try await store.insert(news)
            readingList.append(news)
        } catch {
            print(error)
        }
    }
    
    private func removeFromReadingList(_ id: String) async {
        do {
            try await store.delete(id)
            readingList.removeAll { $0.id == id }
        } catch {
            print(error)
        }
    }
}
