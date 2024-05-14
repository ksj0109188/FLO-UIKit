//
//  PlayerManagerTest.swift
//  FLOTests
//
//  Created by 김성준 on 5/14/24.
//

import XCTest
import Combine
import AVKit
@testable import FLO

final class PlayerManagerTest: XCTestCase {
    var playerManagerMock: playerMangerInOutput! = nil
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        playerManagerMock = PlayerManager()
        let url = URL(string: AppConfigurations().apiBaseURL)!
        playerManagerMock.configure(url: url)
    }
    
    func testPlayerManager_PlayerStart() throws {
        // given
        var isPaused: Bool = true
        playerManagerMock.isPausedSubject
            .sink {
                print("check", $0)
                isPaused = $0
            }
            .store(in: &subscriptions)
        
        //when
        playerManagerMock.togglePlayPause()
        
        //then
        XCTAssertFalse(isPaused) //isPaused true시 재생 실패
    }
    
    func testPlayerManager_PlayerStop() throws {
        // given
        var isPaused: Bool = false
        playerManagerMock.isPausedSubject
            .sink {
                print("check", $0)
                isPaused = $0
            }
            .store(in: &subscriptions)
        
        //when
        playerManagerMock.togglePlayPause()
        playerManagerMock.togglePlayPause()
        
        //then
        XCTAssertTrue(isPaused)
    }
}
