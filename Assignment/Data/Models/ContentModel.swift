//
//  ContentModel.swift
//  Assignment
//
//  Created by Rajneesh Singh on 19/10/26.
//

import Foundation

struct ContentModel: Decodable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: URL
    let videoURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
    }
}

struct HomeContentModel: Decodable {
    let hero: ContentModel
    let trending: [ContentModel]
    let recommended: [ContentModel]
}
