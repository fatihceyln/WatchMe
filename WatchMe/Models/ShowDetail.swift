//
//  ShowDetail.swift
//  WatchMe
//
//  Created by Fatih Kilit on 15.08.2022.
//

import Foundation

struct ShowDetail: Codable {
    let id: Int?
    let name, posterPath, overview: String?
    let numberOfSeasons: Int?
    let firstAirDate, lastAirDate, status: String?
    let genres: [Genre]?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case overview
        case numberOfSeasons = "number_of_seasons"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case status, genres
        case voteAverage = "vote_average"
    }
    
    var startEndDate: String {
        guard
            let firstAirDate = firstAirDate,
            let lastAirDate = lastAirDate else { return "" }
        
        return firstAirDate.prefix(4) + " - " + lastAirDate.prefix(4)
    }
    
    var season: String {
        guard let numberOfSeasons = numberOfSeasons else { return "" }
        
        return "\(numberOfSeasons) Season"
    }
    
    var genresString: String {
        guard let genres = genres else { return "N/A" }
        let names = genres.map({$0.name ?? ""})
        
        return names.joined(separator: ", ")
    }
}
