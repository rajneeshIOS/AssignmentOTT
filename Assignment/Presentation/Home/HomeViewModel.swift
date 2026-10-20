//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Rajneesh Singh on 19/10/26.
//

import Foundation


 class HomeViewModel {

     let fetchHomeContentUseCase: FetchHomeContentUseCase

    var heroContent: Content?
    var trendingContent: [Content] = []
    var recommendedContent: [Content] = []

    var onContentUpdated: (() -> Void)?

    init(fetchHomeContentUseCase: FetchHomeContentUseCase) {
        self.fetchHomeContentUseCase = fetchHomeContentUseCase
    }

     func fetchHomeContent() {
         print("HomeViewModel fetch called")
         let result = fetchHomeContentUseCase.execute()

         heroContent = result.hero
         trendingContent = result.trending
         recommendedContent = result.recommended

         onContentUpdated?()
     }
}
