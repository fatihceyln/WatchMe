//
//  ApiUrls.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import Foundation

// thor id 616037

enum ApiUrls {
    static private let api_key = "b9df2a6976d6dd6ad797595884995d6e"
    static private let baseURL = "https://api.themoviedb.org/3/"
    
    // SHOWS
    static func searchShows(query: String, page: Int = 1) -> String {
        "\(baseURL)search/tv?api_key=\(api_key)&language=en-US&page=\(page)&include_adult=true"
    }
    
    static func dicoverShows(page: Int = 1) -> String {
        "\(baseURL)discover/tv?api_key=\(api_key)&language=en-US&sort_by=popularity.desc&page=\(page)&include_null_first_air_dates=false&with_watch_monetization_types=flatrate&with_status=0&with_type=0"
    }
    
    static func similarShows(showId: String, page: Int = 1) -> String {
        "\(baseURL)tv/\(showId)/similar?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func latestShows(page: Int = 1) -> String {
        "\(baseURL)tv/latest?api_key=\(api_key)&language=en-US"
    }
    
    static func airingTodayShows(page: Int = 1) -> String {
        "\(baseURL)tv/airing_today?api_key=\(api_key)&language=en-US&page=1"
    }
    
    static func onTheAirShows(page: Int = 1) -> String {
        "\(baseURL)tv/on_the_air?api_key=\(api_key)&language=en-US&page=1"
    }
    
    static func popularShows(page: Int = 1) -> String {
        "\(baseURL)tv/popular?api_key\(api_key)&language=en-US&page\(page)"
    }
    
    static func topRatedShows(page: Int = 1) -> String {
        "\(baseURL)tv/popular?api_key\(api_key)&language=en-US&page\(page)"
    }
    
    // MARK: MOVIE
    static func searchMovies(query: String, page: Int = 1) -> String {
        "\(baseURL)search/movie?api_key=\(api_key)&language=en-US&page=\(page)&include_adult=true"
    }
    
    static func discoverMovies(page: Int = 1) -> String {
        "\(baseURL)discover/movie?api_key=\(api_key)&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=\(page)&with_watch_monetization_types=flatrate"
    }
    
    static func similarMovies(movieId: String, page: Int = 1) -> String {
        "\(baseURL)movie/\(movieId)/similar?api_key=\(api_key)&language=en-US&page=\(page)"
    }
    
    static func latestMovies(page: Int = 1) -> String {
        "\(baseURL)movie/latest?api_key=\(api_key)&language=en-US"
    }
    
    static func nowPlayingMovies(page: Int = 1) -> String {
        "\(baseURL)movie/now_playing?api_key=\(api_key)&language=en-US&page=1"
    }
    
    static func popularMovies(page: Int = 1) -> String {
        "\(baseURL)movie/popular?api_key\(api_key)&language=en-US&page\(page)"
    }
    
    static func topRatedMovies(page: Int = 1) -> String {
        "\(baseURL)movie/top_rated?api_key\(api_key)&language=en-US&page\(page)"
    }
    
    static func upcomingMovies(page: Int = 1) -> String {
        "\(baseURL)movie/upcoming?api_key\(api_key)&language=en-US&page\(page)"
    }
}
