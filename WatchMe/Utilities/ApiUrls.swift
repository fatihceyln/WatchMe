//
//  ApiUrls.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import Foundation

// thor id 616037

// "https://api.themoviedb.org/3/person/1654001?api_key=b9df2a6976d6dd6ad797595884995d6e&language=en-US" -> Get a single person

enum ApiUrls {
    static private let api_key = "b9df2a6976d6dd6ad797595884995d6e"
    static private let baseURL = "https://api.themoviedb.org/3/"
    
    // MARK: IMAGE
    static func image(path: String) -> String {
        "https://image.tmdb.org/t/p/w500/\(path)"
    }
    
    // MARK: MULTI SEARCH
    static func multiSearch(query: String) -> String {
        return "\(baseURL)search/multi?api_key=\(api_key)&language=en-US&query=\(query)&page=1&include_adult=false"
    }
    
    // MARK: SHOWS
    static func trendShows() -> String {
        "\(baseURL)trending/tv/day?api_key=\(api_key)"
    }
    
    static func showDetail(id: String) -> String {
        "\(baseURL)tv/\(id)?api_key=\(api_key)"
    }
    
    static func similarShows(showId: String, page: Int) -> String {
        "\(baseURL)tv/\(showId)/similar?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func latestShows(page: Int) -> String {
        "\(baseURL)tv/latest?api_key=\(api_key)&language=en-US"
    }
    
    static func airingTodayShows(page: Int) -> String {
        "\(baseURL)tv/airing_today?api_key=\(api_key)&language=en-US&page=1"
    }
    
    static func onTheAirShows(page: Int) -> String {
        "\(baseURL)tv/on_the_air?api_key=\(api_key)&language=en-US&page=1"
    }
    
    static func popularShows(page: Int) -> String {
        "\(baseURL)tv/popular?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func topRatedShows(page: Int) -> String {
        "\(baseURL)tv/popular?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func showCredits(id: String) -> String {
        return "\(baseURL)tv/\(id)/credits?api_key=\(api_key)&language=en-US"
    }
    
    // MARK: MOVIE
    static func trendMovies() -> String {
        "\(baseURL)trending/movie/day?api_key=\(api_key)"
    }
    
    static func movieDetail(id: String) -> String {
        "\(baseURL)movie/\(id)?api_key=\(api_key)"
    }
    
    static func similarMovies(movieId: String, page: Int) -> String {
        "\(baseURL)movie/\(movieId)/similar?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func latestMovies(page: Int) -> String {
        "\(baseURL)movie/latest?api_key=\(api_key)&language=en-US"
    }
    
    static func nowPlayingMovies(page: Int) -> String {
        "\(baseURL)movie/now_playing?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func popularMovies(page: Int) -> String {
        "\(baseURL)movie/popular?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func topRatedMovies(page: Int) -> String {
        "\(baseURL)movie/top_rated?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func upcomingMovies(page: Int) -> String {
        "\(baseURL)movie/upcoming?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func movieCredits(id: String) -> String {
        return "\(baseURL)movie/\(id)/credits?api_key=\(api_key)&language=en-US"
    }
}
