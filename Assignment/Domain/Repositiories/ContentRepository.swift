//
//  ContentRepository.swift
//  Assignment
//
//  Created by Rajneesh Singh on 19/10/26.
//

import Foundation

protocol ContentRepository {
    func fetchHomeContent() -> HomeContent
}

struct HomeContent {
    let hero: Content
    let trending: [Content]
    let recommended: [Content]
}
