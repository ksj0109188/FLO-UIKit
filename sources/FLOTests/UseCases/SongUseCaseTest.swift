//
//  SongUseCaseTest.swift
//  SongUseCaseTest
//
//  Created by 김성준 on 4/15/24.
//

import XCTest
import Combine
@testable import FLO

final class SongUseCaseTest: XCTestCase {
    var subscriptions = Set<AnyCancellable>()

    func testSongUseCase_fetchData() throws {
        //given
        let expectation = XCTestExpectation(description: "Fetch song data")
        let useCaseMock = FetchSongUseCase(songWebRepository: SongWebRepositoryMock())
        
        //when
        useCaseMock.fetchData()
            .sink{
                _ in expectation.fulfill()
            }receiveValue: {
                //then
                XCTAssertNotNil($0)
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
