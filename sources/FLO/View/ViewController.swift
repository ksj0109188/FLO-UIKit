//
//  ViewController.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import UIKit
import AVKit

protocol PlayControlViewDelegate: AnyObject {
    func togglePlayPause()
    func sliderValueChanged(to value: Float)
}

class ViewController: UIViewController {
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
   
    private lazy var playView: PlayInfoView = {
        let playView = PlayInfoView()
        playView.translatesAutoresizingMaskIntoConstraints = false
        
        return playView
    }()
    
    private lazy var playControlView: PlayControlView = {
        let playControlView = PlayControlView()
        playControlView.player = player
        playControlView.delegate = self
        playControlView.translatesAutoresizingMaskIntoConstraints = false
        
        return playControlView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubviews(playView, playControlView)
    }
    
    private func setupPlayer() {
        let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3")!
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        
        view.layer.addSublayer(playerLayer)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            playView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            playView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            playView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
            
            playControlView.topAnchor.constraint(equalTo: playView.bottomAnchor),
            playControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            playControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playControlView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            playControlView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5)
        ])
    }
}

extension ViewController: PlayControlViewDelegate {
    func togglePlayPause() {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func sliderValueChanged(to value: Float) {
        let seconds = Int64(value)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: targetTime)
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}
