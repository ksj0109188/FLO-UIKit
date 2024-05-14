//
//  PlaySongViewModel.swift
//  FLOTests
//
//  Created by 김성준 on 5/13/24.
//

import XCTest
import Combine
import AVKit
@testable import FLO

final class PlaySongViewModelTest: XCTestCase {
    var songDTO: SongDTO!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let expectation = XCTestExpectation(description: "Fetch song data")
        let usecase = FetchSongUseCase(songWebRepository: SongWebRepositoryMock())
        
        usecase.fetchData()
            .sink{
                _ in expectation.fulfill()
            }receiveValue: { [weak self] songDTO in
                XCTAssertNotNil(songDTO, "")
                self?.songDTO = songDTO
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPlaySongSceneViewModel_withSyncLyrics() {
        //given
        let usecaseMock = FetchSongUseCase(songWebRepository: SongWebRepositoryMock())
        let playManagerMock = PlayerManager()
        let actionsMock = PlaySongSceneViewModelActions { _, _ in }
        
        var viewModelMock: PlaySongSceneViewModelInOutput = PlaySongSceneViewModel(fetchSongUseCase: usecaseMock, playerManager: playManagerMock, actions: actionsMock)
        viewModelMock.songDTO = songDTO
        let time = CMTime(value: CMTimeValue(0.0), timescale: 1)
        
        //when
        let lyrics = viewModelMock.syncLyrics(time: time, inputTimeType: .seconds)
        
        //then
        XCTAssertEqual(lyrics.count == 2, true, "syncLyrics method must return tuple which has two count")
    }
    
}
