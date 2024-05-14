//
//  DetailLyricsViewModelTest.swift
//  FLOTests
//
//  Created by 김성준 on 5/13/24.
//

import XCTest
import AVKit
import Combine
@testable import FLO

final class DetailLyricsViewModelTest: XCTestCase {
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
    
    func testDetailLyricsViewModel_withSyncLyrics() {
        //given
        let playManagerMock = PlayerManager()
        let actionsMock = DetailLyricsViewModelActions {  }
        
        let viewModelMock: DetailLyricsViewModelInOutput = DetailLyricsViewModel(songDTO: songDTO, playerManger: playManagerMock, actions: actionsMock)
        let time = CMTime(value: CMTimeValue(0.0), timescale: 1)
        
        //when
        let lyrics = viewModelMock.getCurrentLyricsIndex(time: time, inputTimeType: .seconds)
        
        //then
        XCTAssertEqual(lyrics == 0, true)
    }

}
