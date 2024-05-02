//
//  PlayControlView.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit
import AVKit

class PlayControlView: UIView {
    weak var delegate: PlayControlDelegate?
    var viewModel: PlaySongSceneViewModel! {
        didSet {
            viewModel.playerManager.observer { [weak self] time in
                self?.updateUI(time: time)
            }
        }
    }
    
    private lazy var seekSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
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
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(seekSlider, playButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configure(with songDTO: SongDTO) {
        seekSlider.maximumValue = Float(songDTO.duration)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            seekSlider.topAnchor.constraint(equalTo: topAnchor),
            seekSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            seekSlider.widthAnchor.constraint(equalTo: widthAnchor),
            
            playButton.topAnchor.constraint(equalTo: seekSlider.bottomAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func updateUI(time: CMTime) {
        seekSlider.value = Float(time.seconds)
    }
    
    @objc func seekSliderChanged(_ sender: UISlider) {
        delegate?.sliderValueChanged(to: sender.value)
    }

    @objc func togglePlayPause() {
        delegate?.togglePlayPause()
    }
}
