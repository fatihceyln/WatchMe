//
//  Video.swift
//  WatchMe
//
//  Created by Fatih Kilit on 22.08.2022.
//

import Foundation

struct Video: Codable {
    let results: [VideoResult]?
}

struct VideoResult: Codable {
    let key: String?
    let type: String?
}
