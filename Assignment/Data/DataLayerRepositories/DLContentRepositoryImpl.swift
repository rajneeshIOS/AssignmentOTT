//
//  DLContentRepositoryImpl.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import Foundation
class DLContentRepositoryImpl:ContentRepository{
    let dataSource: LocalJSONDataSource
    
    init(dataSource: LocalJSONDataSource) {
        self.dataSource = dataSource
    }
     func mapContent(_ model: ContentModel) -> Content {
           return Content(
               id: model.id,
               title: model.title,
               description: model.description,
               thumbnailURL: model.thumbnailURL,
               videoURL: model.videoURL
           )
       }
    func fetchHomeContent() -> HomeContent {
        print("Repository fetch called")
        guard let homeData = dataSource.fetchHomeContent() else{
            print("JSON failed")
            let emptyContent = Content(id: "", title: "", description: "", thumbnailURL: URL(string: "https://example.com")!, videoURL: URL(string: "https://example.com")!)
            
            return HomeContent(hero: emptyContent, trending: [], recommended: [])
        }
        print("JSON loaded successfully:", homeData.hero.title)
        let hero = mapContent(homeData.hero)
        let trending = homeData.trending.map { mapContent($0) }
        let recommended = homeData.recommended.map { mapContent($0) }
        
        return HomeContent(hero: hero, trending: trending, recommended: recommended)
        }
    }
    
