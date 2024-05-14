//
//  NetworkServicceTest.swift
//  FLOTests
//
//  Created by 김성준 on 5/8/24.
//

import XCTest
import Combine
@testable import FLO

///note: 네트워크 전송계층 실패/성공 테스트
final class NetworkServicceTest: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    
    final class ErrorWebRepositryMock: WebRepository {
        var baseURL: String = ""
        
        func request() -> AnyPublisher<FLO.SongDTO, any Error>  {
            call()
        }
    }
    
    final class SuccessWebRepositryMock: WebRepository {
        var baseURL: String = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
        
        func request() -> AnyPublisher<FLO.SongDTO, any Error>  {
            call()
        }
    }

    func testWebRepository_withSuccess() throws {
        //given
        let expectation = XCTestExpectation(description: "testWebRepository_withSuccess")
        let repository = SuccessWebRepositryMock()
        
        //when
        repository.request()
            .sink{ _ in
                expectation.fulfill()
            }receiveValue: {
                //then
                XCTAssertNotNil($0, "Songdata fetch fail")
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testWebRepository_withFailure_invalidURL() throws {
        //given
        let expectation = XCTestExpectation(description: "testWebRepository_withFailure_invalidURL")
        let repository = ErrorWebRepositryMock()
        
        //when
        repository.request()
            .sink{ completion in
                //then
                switch completion {
                    case .finished:
                        XCTAssertTrue(false, "this case couldn't finshied")
                    case .failure(let error):
                        debugPrint(error)
                }
                expectation.fulfill()
            }receiveValue: { _ in }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
