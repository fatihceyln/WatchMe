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
    
    func downloadMovies(urlString: String, completion: @escaping (Result<[MovieResult], ErrorMessage>) -> ()) {
        
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
                let moviesData = try JSONDecoder().decode(Movie.self, from: data)
                
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
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        .resume()
    }
    
    func downloadMovieDetail(urlString: String, completion: @escaping (Result<MovieDetail, ErrorMessage>) -> ()) {
        
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
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                
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
}
