//
//  Actor.swift
//  WatchMe
//
//  Created by Fatih Kilit on 20.08.2022.
//

import Foundation

struct Person: Codable {
    let biography, birthday, deathday: String?
    let id: Int?
    let name, placeOfBirth, profilePath: String?

    enum CodingKeys: String, CodingKey {
        case biography, birthday, deathday, id, name
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
    
    var birthDeathDay: String {
        guard let birthday = birthday else {
            return "N/A"
        }
        
        guard let deathday = deathday else {
            return birthday.replacingOccurrences(of: "-", with: "/")
        }
        
        return birthday.replacingOccurrences(of: "-", with: "/") + " - " + deathday.replacingOccurrences(of: "-", with: "/")
    }
    
    var birthLocation: String {
        guard placeOfBirth != "" else { return "N/A"}
        return placeOfBirth ?? "N/A"
    }
}
