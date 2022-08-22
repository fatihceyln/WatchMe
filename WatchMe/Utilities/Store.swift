//
//  Store.swift
//  WatchMe
//
//  Created by Fatih Kilit on 22.08.2022.
//

import Foundation

enum Store {
    static private let defaults = UserDefaults.standard
    
    static let key = "content"
    
    static func update(content: ContentDetail) {
        retrieveContents { result in
            switch result {
            case .success(var contents):
                if contents.contains(where: {$0.id == content.id}) {
                    contents.removeAll(where: {$0.id == content.id})
                } else {
                    contents.append(content)
                }
                
                saveContents(contents: contents)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func retrieveContents(completion: @escaping (Result<[ContentDetail], ErrorMessage>) -> ()) {
        guard let contentsData = defaults.object(forKey: key) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let contents = try JSONDecoder().decode([ContentDetail].self, from: contentsData)
            
            completion(.success(contents))
        } catch {
            completion(.failure(.unknown))
        }
    }
    
    private static func saveContents(contents: [ContentDetail]) {
        do {
            let encodedContents = try JSONEncoder().encode(contents)
            defaults.set(encodedContents, forKey: key)
        } catch {
            print(error)
        }
    }
    
    static func isSaved(content: ContentDetail) -> Bool {
        var isSaved = false
        
        retrieveContents { result in
            switch result {
            case .success(let contents):
                if contents.contains(where: {$0.id == content.id}) {
                    isSaved = true
                    return
                }
                
                isSaved = false
                return
                
            case .failure(let error):
                print(error)
            }
        }
        
        return isSaved
    }
}
