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
        label.text = " "
        label.textColor = .white
        label.numberOfLines = 1
        label.layer.borderColor = CGColor.init(red: 10.0, green: 10.0, blue: 10.0, alpha: 0.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var secondLyricsLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = .white
        label.numberOfLines = 1
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
    
    //TODO: Private 전체적으로 추가 필요
    private func setupViews() {
        addSubviews(firstLyricsLabel, secondLyricsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            firstLyricsLabel.topAnchor.constraint(equalTo: topAnchor),
            firstLyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstLyricsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstLyricsLabel.widthAnchor.constraint(equalTo: widthAnchor),
            firstLyricsLabel.heightAnchor.constraint(equalTo: heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            secondLyricsLabel.topAnchor.constraint(equalTo: firstLyricsLabel.bottomAnchor),
            secondLyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondLyricsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondLyricsLabel.widthAnchor.constraint(equalTo: widthAnchor),
            secondLyricsLabel.heightAnchor.constraint(equalTo: heightAnchor)
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
        //TODO: Font상수화나 extension으로 별도 파일로 관리하기
        if lyrics.count == 2 {
            if lyrics[0].1 == .HighLight {
                firstLyricsLabel.font = .boldSystemFont(ofSize: 16)
                secondLyricsLabel.font = .systemFont(ofSize: 16)
            } else if lyrics[1].1 == .HighLight {
                firstLyricsLabel.font = .systemFont(ofSize: 16)
                secondLyricsLabel.font = .boldSystemFont(ofSize: 16)
            } else {
                firstLyricsLabel.font = .systemFont(ofSize: 16)
                secondLyricsLabel.font = .systemFont(ofSize: 16)
            }
            
            firstLyricsLabel.text = lyrics[0].0
            secondLyricsLabel.text = lyrics[1].0
        }
    }
    
}
