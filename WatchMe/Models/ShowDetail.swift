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
    let numberOfEpisodes, numberOfSeasons: Int?
    let episodeRunTime: [Int]?
    let firstAirDate, lastAirDate, status: String?
    let genres: [Genre]?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case overview
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case status, genres
        case voteAverage = "vote_average"
    }
}
