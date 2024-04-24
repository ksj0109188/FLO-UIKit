//
//  LyricsView.swift
//  FLO
//
//  Created by 김성준 on 4/19/24.
//

import UIKit
import AVKit

class PlayLyricsView: UIView {
    var playerManger: PlayerManager? {
        didSet {
            playerManger?.observer { [weak self] time in
                self?.updateUI(time: time)
            }
        }
    }
    
    private lazy var lyricsLabel: UILabel = {
        let label = UILabel()
        label.text = "Start!!!"
        label.numberOfLines = 2
        label.layer.borderColor = CGColor.init(red: 10.0, green: 10.0, blue: 10.0, alpha: 0.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubviews(lyricsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            lyricsLabel.topAnchor.constraint(equalTo: topAnchor),
            lyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lyricsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            lyricsLabel.widthAnchor.constraint(equalTo: widthAnchor),
            lyricsLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func updateUI(time: CMTime) {
        let milliseconds = Int(CMTimeGetSeconds(time) * 1000)
        let Lyrics = Song.dummy.transformedLyrics
        var keys = Array(Lyrics.keys)
        
        keys.sort { $0 < $1}
        
        if keys.count > 0 {
            let target = keys.filter { $0 <= milliseconds}.max() ?? 0
            let targetIndex = keys.firstIndex(of: target)
            
            if targetIndex == nil {
                lyricsLabel.text = "\(Lyrics[keys[0]] ?? "")\n \(Lyrics[keys[1]] ?? "")"
            } else if let index = targetIndex, index + 1 < keys.count - 1 {
                lyricsLabel.text = "\(Lyrics[keys[index]] ?? "")\n \(Lyrics[keys[index + 1]] ?? "")"
            }
        }
    }
    
}
