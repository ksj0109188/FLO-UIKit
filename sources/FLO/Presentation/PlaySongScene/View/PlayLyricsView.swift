//
//  LyricsView.swift
//  FLO
//
//  Created by 김성준 on 4/19/24.
//

import UIKit
import AVKit

final class PlayLyricsView: UIView {
    var viewModel: PlaySongSceneViewModel! {
        didSet {
            viewModel.playerManager.observer { [weak self] time in
                self?.updateUI(time: time)
            }
        }
    }
    
    private lazy var firstLyricsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = .contentFont
     
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var secondLyricsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = .contentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(firstLyricsLabel, secondLyricsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            firstLyricsLabel.topAnchor.constraint(equalTo: topAnchor),
            firstLyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstLyricsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            secondLyricsLabel.topAnchor.constraint(equalTo: firstLyricsLabel.bottomAnchor),
            secondLyricsLabel.leadingAnchor.constraint(equalTo: firstLyricsLabel.leadingAnchor),
            secondLyricsLabel.trailingAnchor.constraint(equalTo: firstLyricsLabel.trailingAnchor),
            secondLyricsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(with songDTO: SongDTO, viewModel: PlaySongSceneViewModel) {
        self.viewModel = viewModel
        let timeLineLyrics = songDTO.timeLineLyrics
        let transformedLyrics = songDTO.transformedLyrics
    
        if timeLineLyrics.count > 0 {
            firstLyricsLabel.text = transformedLyrics[timeLineLyrics[0]]
            secondLyricsLabel.text = transformedLyrics[timeLineLyrics[1]]
        }
    }
    
    func updateUI(time: CMTime = CMTime(value: CMTimeValue(0.0), timescale: 1)) {
        let lyrics = viewModel.syncLyrics(time: time, inputTimeType: .seconds)

        if lyrics.count == 2 {
            if lyrics[0].1 == .HighLight {
                firstLyricsLabel.font =  .contentBoldFont
                secondLyricsLabel.font = .contentFont
                firstLyricsLabel.textColor = .white
                secondLyricsLabel.textColor = .gray
            } else if lyrics[1].1 == .HighLight {
                firstLyricsLabel.font = .contentFont
                secondLyricsLabel.font = .contentBoldFont
                firstLyricsLabel.textColor = .gray
                secondLyricsLabel.textColor = .white
            } else {
                firstLyricsLabel.font = .contentFont
                secondLyricsLabel.font = .contentFont
                firstLyricsLabel.textColor = .gray
                secondLyricsLabel.textColor = .gray
            }
            
            firstLyricsLabel.text = lyrics[0].0
            secondLyricsLabel.text = lyrics[1].0
        }
    }
    
}
