//
//  SongWebRepositoryMock.swift
//  FLOTests
//
//  Created by 김성준 on 5/13/24.
//

import Foundation
import Combine
@testable import FLO

final class SongWebRepositoryMock: SongWebRepository {
    var baseURL: String = AppConfigurations().apiBaseURL
    
    func loadSong() -> AnyPublisher<FLO.SongDTO, any Error> {
        call()
    }

}

