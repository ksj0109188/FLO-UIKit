//
//  PlayerManager.swift
//  FLO
//
//  Created by 김성준 on 4/18/24.
//

import Foundation
import AVKit

class PlayerManager {
    var player: AVPlayer!
//    private var playerLayer: AVPlayerLayer!
    private var timeObserverToken: Any?
    
    init() {
        setupPlayer()
    }
    
    deinit() {
        removeObserver() 
    }
    
    private func setupPlayer() {
        let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3")!
        player = AVPlayer(url: url)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        
//        view.layer.addSublayer(playerLayer)
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
    
}


