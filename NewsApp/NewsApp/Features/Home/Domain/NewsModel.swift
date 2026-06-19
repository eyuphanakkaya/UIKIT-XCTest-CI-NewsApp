//
//  NewsModel.swift
//  NewsApp
//
//  Created by Eyüphan Akkaya on 16.06.2026.
//

import Foundation

public struct NewsModel: Equatable {
    public let id: String
    public let title: String
    public let imageURL: String?
    public let creator: [String]?
    public let pubDate: String
    public let description: String?
    
    var creatorText: String? {
        creator?.joined(separator: ", ").capitalized
    }
}
