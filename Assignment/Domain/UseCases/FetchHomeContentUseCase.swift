//
//  FetchHomeContentUseCase.swift
//  Assignment
//
//  Created by Rajneesh Singh on 19/10/26.
//

import Foundation
class FetchHomeContentUseCase {

    private let repository: ContentRepository

    init(repository: ContentRepository) {
        self.repository = repository
    }

    func execute() -> HomeContent {
        return repository.fetchHomeContent()
    }
}
