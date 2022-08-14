//
//  CastModel.swift
//  WatchMe
//
//  Created by Fatih Kilit on 14.08.2022.
//

import Foundation

struct CastModel: Codable {
    let cast: [Cast]?
}

struct Cast: Codable {
    let name: String?
    let profilePath: String?
    let character: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case character
    }
}
