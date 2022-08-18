//
//  MovieDetail.swift
//  WatchMe
//
//  Created by Fatih Kilit on 14.08.2022.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int?
    let title, overview, posterPath, releaseDate: String?
    let runtime: Int?
    let genres: [Genre]?
    let homepage: String?
    let imdbID: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime, genres, homepage
        case imdbID = "imdb_id"
        case voteAverage = "vote_average"
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
        return releaseDate?.replacingOccurrences(of: "-", with: "/") ?? "N/A"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
