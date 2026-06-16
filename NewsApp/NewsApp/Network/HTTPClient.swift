//
//  HTTPClient.swift
//  NewsApp
//
//  Created by Eyüphan Akkaya on 16.06.2026.
//

import Foundation

protocol HTTPClient {
    func get(url: URL) async throws -> (Data, HTTPURLResponse)
}
