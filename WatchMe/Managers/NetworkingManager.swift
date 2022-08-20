//
//  NetworkingManager.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

enum ErrorMessage: String, Error {
    case unknown = "Unknown error occured!"
}

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
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
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
                completion(.failure(.unknown))
            }
        }
        .resume()
    }
    
    func downloadContentDetail(urlString: String, completion: @escaping (Result<ContentDetail, ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let movieDetail = try JSONDecoder().decode(ContentDetail.self, from: data)
                
                completion(.success(movieDetail))
            } catch {
                completion(.failure(.unknown))
            }
        }
        .resume()
    }
    
    func downloadCast(urlString: String, completion: @escaping (Result<[Cast], ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
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
                completion(.failure(.unknown))
            }
        }
        .resume()
    }
    
    func downloadContentBySearch(urlString: String, completion: @escaping (Result<[SearchResult], ErrorMessage>) ->()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
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
                completion(.failure(.unknown))
            }
        }
        .resume()
    }
    
    func downloadPerson(urlString: String, completion: @escaping (Result<Person, ErrorMessage>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                
                completion(.success(person))
                
            } catch {
                completion(.failure(.unknown))
            }
        }
        .resume()
    }
}
