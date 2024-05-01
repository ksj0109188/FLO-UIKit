//
//  FetchSongUseCase.swift
//  FLO
//
//  Created by 김성준 on 4/25/24.
//

import Foundation
import Combine

final class FetchSongUseCase {
    private let songWebRepository: SongWebRepository
    
    init(songWebRepository: SongWebRepository) {
        self.songWebRepository = songWebRepository
    }
    
    func fetchData() -> AnyPublisher<SongDTO, Error> {
        songWebRepository.loadSong()
    }
    
}
