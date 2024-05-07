//
//  PlayerManager.swift
//  FLO
//
//  Created by 김성준 on 4/18/24.
//

import AVKit
import Combine

protocol PlayableViewModel {
    var playerManager: PlayerManager {get}
}
protocol playerMangerInput {
    func configure(url: URL)
    func togglePlayPause()
    func moveToTimeLine(to time: CMTime)
}

protocol playerMangerOutput {
    var isPausedSubject: CurrentValueSubject<Bool, Never> { get }
    func observer(update: @escaping (CMTime) -> Void)
    func playerTime() -> CMTime
}

typealias playerMangerInOutput = playerMangerInput & playerMangerOutput

final class PlayerManager: playerMangerInOutput {
    private var player: AVPlayer!
    private var timeObserverToken: Any?
    private var isPlayerPuased: Bool = true
    let isPausedSubject = CurrentValueSubject<Bool, Never>(true)
    
    deinit {
        removeObserver()
    }
    
    private func removeObserver() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func configure(url: URL) {
        player = AVPlayer(url: url)
    }
    
    func observer(update: @escaping (CMTime) -> Void) {
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: update)
        
    }
    
    func togglePlayPause() {
        isPlayerPuased ? player.play() : player.pause()
        isPlayerPuased.toggle()
        
        isPausedSubject.send(isPlayerPuased)
    }
    
    func moveToTimeLine(to time: CMTime) {
        player.seek(to: time)
    }
    
    func playerTime() -> CMTime {
        return player.currentTime()
    }
}
