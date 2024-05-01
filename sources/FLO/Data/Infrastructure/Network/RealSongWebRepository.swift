//
//  NetworkService.swift
//  FLO
//
//  Created by 김성준 on 4/22/24.
//

import Foundation
import Combine

protocol SongWebRepository: WebRepository {
    func loadSong() -> AnyPublisher<SongDTO, Error>
}

struct RealSongWebRepository: SongWebRepository {
    var baseURL: String
    
    init(config: AppConfigurations) {
        self.baseURL = config.apiBaseURL
    }
    
    func loadSong() -> AnyPublisher<SongDTO, any Error> {
        return call()
    }
}

