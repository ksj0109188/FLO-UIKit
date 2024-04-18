//
//  PlayControlView.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit
import AVKit
import AVFoundation

class PlayControlView: UIView {
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var timeObserverToken: Any?
    
    private lazy var seekSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = Float(Song.dummy.duration)
        slider.addTarget(self, action: #selector(seekSliderChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        return slider
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var lyricsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.layer.borderColor = CGColor.init(red: 10.0, green: 10.0, blue: 10.0, alpha: 0.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    deinit {
        if let token = timeObserverToken {
             player.removeTimeObserver(token)
             timeObserverToken = nil
         }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
        setupViews()
        syncComponents(player: player)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(seekSlider, playButton, lyricsLabel)
    }
    
    private func setupPlayer() {
        let url = URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3")!
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        
        layer.addSublayer(playerLayer)
    }
    
    private func syncComponents(player: AVPlayer) {
        
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            
            self?.seekSlider.value = Float(time.seconds)
            
            let milliseconds = Int(CMTimeGetSeconds(time) * 1000)
            let Lyrics = Song.dummy.transformedLyrics
            var keys = Array(Lyrics.keys)
            
            keys.sort { $0 < $1}
            
            if keys.count > 0 {
                let target = keys.filter { $0 <= milliseconds}.max() ?? 0
                let targetIndex = keys.firstIndex(of: target)
                
                if targetIndex == nil {
                    self?.lyricsLabel.text = "\(Lyrics[keys[0]] ?? "")\n \(Lyrics[keys[1]] ?? "")"
                } else if let index = targetIndex, index + 1 < keys.count - 1 {
                    self?.lyricsLabel.text = "\(Lyrics[keys[index]] ?? "")\n \(Lyrics[keys[index + 1]] ?? "")"
                }
            }
        }
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            lyricsLabel.topAnchor.constraint(equalTo: topAnchor),
            lyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lyricsLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            seekSlider.topAnchor.constraint(equalTo: lyricsLabel.bottomAnchor),
            seekSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            seekSlider.widthAnchor.constraint(equalTo: widthAnchor),
            
            playButton.topAnchor.constraint(equalTo: seekSlider.bottomAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    @objc func seekSliderChanged(_ sender: UISlider) {
        let seconds = Int64(sender.value)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: targetTime)
    }

    @objc func togglePlayPause() {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
}