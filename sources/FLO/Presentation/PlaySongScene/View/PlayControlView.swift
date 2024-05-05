//
//  PlayControlView.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit
import AVKit

//TODO: Delegate 다시 생각해보기
//TODO: PlayControl 공통 컴포넌트로 분리하기
protocol PlayControlDelegate: AnyObject {
    func togglePlayPause()
    func sliderValueChanged(to value: Float)
}

final class PlayControlView: UIView {
    weak var delegate: PlayControlDelegate?
    private var isSliderBeingTouched = false
    
    private lazy var seekSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        slider.addTarget(self, action: #selector(seekSliderChanged(_:)), for: .touchUpInside)
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
        ])
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: seekSlider.bottomAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    func updateUI(time: CMTime) {
        if !isSliderBeingTouched {
            seekSlider.value = Float(time.seconds)
        }
    }
    
    @objc func seekSliderChanged(_ sender: UISlider) {
        delegate?.sliderValueChanged(to: sender.value)
        ///notes: updateUI를 통해 두번 seekSlider value가 업데이트 되는걸 방지
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: DispatchWorkItem(block: {
            self.allowSliderUpdate()
        }))
    }
    
    @objc func togglePlayPause() {
        delegate?.togglePlayPause()
    }
    
    private func allowSliderUpdate() {
        isSliderBeingTouched = false
    }
    
    @objc func sliderTouchDown(_ sender: UISlider) {
        isSliderBeingTouched = true
    }
}
