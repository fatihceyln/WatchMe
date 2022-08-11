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
    
    func getPopularMovies(page: Int, completion: @escaping (Result<[PopularMoviesResult], ErrorMessage>) -> ()) {
        
        guard let url = URL(string: ApiUrls.popularMovies(page: page)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            print(url)
            if let _ = error {
                completion(.failure(.unknown))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                print("ad")
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let popularMoviesData = try JSONDecoder().decode(PopularMovies.self, from: data)
                
                guard let results = popularMoviesData.results else {
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
        guard let url = URL(string: urlString) else { return }
        
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
            
            completion(image)
        }
        .resume()
    }
}
