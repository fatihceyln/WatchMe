//
//  NetworkingManager.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

final class NetworkingManager {
    static let shared = NetworkingManager()
    private init() {}
    
    let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 250
        return cache
    }()
    
    func downloadContent(urlString: String, completion: @escaping (Result<[ContentResult], ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let moviesData = try JSONDecoder().decode(Content.self, from: data)
                
                guard let results = moviesData.results else {
                    completion(.failure(.unknown))
                    return
                }
                
                completion(.success(results))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        .resume()
    }
    
    func downloadContentDetail(urlString: String, completion: @escaping (Result<ContentDetail, ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let movieDetail = try JSONDecoder().decode(ContentDetail.self, from: data)
                
                completion(.success(movieDetail))
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        .resume()
    }
    
    func downloadCast(urlString: String, completion: @escaping (Result<[Cast], ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let castModel = try JSONDecoder().decode(CastModel.self, from: data)
                
                guard let cast = castModel.cast else {
                    completion(.failure(.unknown))
                    return
                }
                
                completion(.success(cast))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        .resume()
    }
    
    func downloadContentBySearch(urlString: String, completion: @escaping (Result<[SearchResult], ErrorMessage>) ->()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let searchData = try JSONDecoder().decode(SearchModel.self, from: data)
                
                guard let results = searchData.results else {
                    completion(.failure(.unknown))
                    return
                }
                
                completion(.success(results.filter({$0.mediaType == .movie || $0.mediaType == .tv})))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        .resume()
    }
    
    func downloadPerson(urlString: String, completion: @escaping (Result<Person, ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                
                completion(.success(person))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        .resume()
    }
    
    func downloadPersonContent(urlString: String, completion: @escaping (Result<[ContentResult], ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let personContent = try JSONDecoder().decode(PersonContent.self, from: data)
                
                guard let castContent = personContent.cast else {
                    completion(.failure(.unknown))
                    return
                }
                
                var result = castContent
                
                result = result.filter({$0.posterPath != nil && ($0.title != nil || $0.name != nil)})
                result = result.sorted(by: {$0.releaseDate ?? "" > $1.releaseDate ?? ""})
                
                var nonDuplicatedResult: [ContentResult] = []
                
                for item in result {
                    if !nonDuplicatedResult.contains(where: {$0.id == item.id}) {
                        nonDuplicatedResult.append(item)
                    }
                }
                
                completion(.success(nonDuplicatedResult))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        .resume()
    }
    
    func downloadVideo(urlString: String, completion: @escaping (VideoResult?) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil)
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let video = try JSONDecoder().decode(Video.self, from: data)
                
                guard let videoResults = video.results else { completion(nil); return }
                
                guard let trailer = videoResults.first(where: {$0.type == "Trailer"}) else { completion(nil); return }
                
                completion(trailer)
                
            } catch {
                completion(nil)
            }
        }
        .resume()
    }
}
