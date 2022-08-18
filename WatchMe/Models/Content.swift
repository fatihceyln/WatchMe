//
//  Content.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import Foundation

struct Content: Codable {
    let page: Int?
    let results: [ContentResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct ContentResult: Codable, Hashable {
    let id: Int?
    let overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title, name: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, name
        case voteAverage = "vote_average"
    }
}
