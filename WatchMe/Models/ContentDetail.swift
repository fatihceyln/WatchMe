//
//  ContentDetail.swift
//  WatchMe
//
//  Created by Fatih Kilit on 14.08.2022.
//

import Foundation

struct ContentDetail: Codable {
    let id: Int?
    let title, name, overview, posterPath, releaseDate: String?
    let numberOfSeasons: Int?
    let firstAirDate, lastAirDate, status: String?
    let runtime: Int?
    let genres: [Genre]?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case numberOfSeasons = "number_of_seasons"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case status, runtime, genres
        case voteAverage = "vote_average"
    }
    
    var isMovie: Bool {
        title != nil && name == nil
    }
    
    var genresString: String {
        guard let genres = genres, !genres.isEmpty else { return "N/A" }
        let names = genres.map({$0.name ?? ""})
        
        return names.joined(separator: ", ")
    }
    
    var runtimeString: String {
        guard let runtime = runtime, runtime != 0 else {
            return "N/A"
        }
        
        let hour = runtime / 60
        let minute = runtime % 60
        
        let hourString = hour == 0 ? "" : "\(hour)h "
        let minuteString = minute == 0 ? "" : "\(minute)m"
        
        return hourString + minuteString
    }
    
    var releaseDateString: String {
        guard releaseDate != "" else { return "N/A"}
        return releaseDate?.replacingOccurrences(of: "-", with: " / ") ?? "N/A"
    }
    
    var startEndDate: String {
        guard let firstAirDate = firstAirDate else {
            return "N/A"
        }
        
        guard let lastAirDate = lastAirDate else {
            return String(firstAirDate.prefix(4))
        }
        
        return firstAirDate.prefix(4) + " - " + lastAirDate.prefix(4)
    }
    
    var season: String {
        guard let numberOfSeasons = numberOfSeasons else { return "N/A" }
        
        return "\(numberOfSeasons) Season"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
