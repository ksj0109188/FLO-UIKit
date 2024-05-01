//
//  PlayerManager.swift
//  FLO
//
//  Created by 김성준 on 4/18/24.
//

import Foundation
import AVKit

class PlayerManager {
    private var player: AVPlayer!
    private var timeObserverToken: Any?
    
    init() {
        setupPlayer()
    }
    
    deinit {
        removeObserver()
    }
    
    private func setupPlayer() {
        let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3")!
        player = AVPlayer(url: url)
    }
    
    func removeObserver() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func observer(update: @escaping (CMTime) -> Void) {
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main,using: update)
    }
    
    func pausePlayer() {
        player.rate == 0 ? player.play() : player.pause()
    }
    
    func moveToTimeLine(to time: CMTime) {
        player.seek(to: time)
    }
    
}


