//
//  PlayerEventHandler.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import Foundation
enum PlayerEvent {
    case ready
    case started
    case paused
    case seeked
    case completed
    case error(String)

    var eventName: String {
        switch self {
        case .ready:
            return "PLAYER_READY"
        case .started:
            return "PLAYER_STARTED"
        case .paused:
            return "PLAYER_PAUSED"
        case .seeked:
            return "PLAYER_SEEKED"
        case .completed:
            return "PLAYER_COMPLETED"
        case .error:
            return "PLAYER_ERROR"
        }
    }
}

class PlayerEventHandler {

    func handle(event: PlayerEvent) {
        switch event {
        case .error(let message):
            print("\(event.eventName): \(message)")
        default:
            print(event.eventName)
        }
    }
}
