//
//  SearchModel.swift
//  WatchMe
//
//  Created by Fatih Kilit on 18.08.2022.
//

import Foundation

struct SearchModel: Codable {
    let page: Int?
    let results: [SearchResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct SearchResult: Codable {
    let firstAirDate: String?
    let id: Int?
    let mediaType: MediaType?
    let name: String?
    let posterPath: String?
    let releaseDate, title: String?

    enum CodingKeys: String, CodingKey {
        case firstAirDate = "first_air_date"
        case id
        case mediaType = "media_type"
        case name
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}
