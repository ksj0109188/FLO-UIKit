//
//  FLOTests.swift
//  FLOTests
//
//  Created by 김성준 on 4/15/24.
//

import XCTest
import Combine
@testable import FLO



final class FLOTests: XCTestCase {
    var subsciprtion = Set<AnyCancellable>()
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    final class SongWebRepositoryMock: SongWebRepository {
        func loadSong() -> AnyPublisher<FLO.SongDTO, any Error> {
            call()
        }
        
        var baseURL: String = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
    }
    
  
    

    func testExample() throws {
        //given
        //when
        //then
        let expectation = XCTestExpectation(description: "Fetch song data")
        let useCaseMock = FetchSongUseCase(songWebRepository: SongWebRepositoryMock())
        useCaseMock.fetchData()
            .sink{
                _ in expectation.fulfill()
            }receiveValue: {
                XCTAssertNotNil($0)
            }
            .store(in: &subsciprtion)
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
//        self.measure {
            // Put the code you want to measure the time of here.
//        }
    }

}
