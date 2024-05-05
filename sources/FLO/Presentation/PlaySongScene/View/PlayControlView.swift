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
    private var isPlayButtonTouched = false
    
    private var minValueLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = .subContentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var maxValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .subContentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var seekSlider: UISlider = {
        let slider = UISlider()
        let transparentImage = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in }
        
        slider.minimumValue = 0.0
        slider.tintColor = UIColor(named: "SeekbarColor")
        slider.setThumbImage(transparentImage, for: .normal)
        slider.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        slider.addTarget(self, action: #selector(seekSliderChanged(_:)), for: .touchUpInside)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        return slider
    }()
    
    private lazy var playImage: UIImage = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "play.fill", withConfiguration: configuration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        return image!
    }()
    
    private lazy var pauseImage: UIImage = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        return image!
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = playImage
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        addSubviews(seekSlider, minValueLabel, maxValueLabel, playButton)
    }
    
    func configure(with songDTO: SongDTO) {
        seekSlider.maximumValue = Float(songDTO.duration)
        maxValueLabel.text = formatSecondsToMinutesSeconds(songDTO.duration)
    }
    
    private func setupConstraints() {
        let padding = 20.0
        NSLayoutConstraint.activate([
            seekSlider.topAnchor.constraint(equalTo: topAnchor),
            seekSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            seekSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
        
        NSLayoutConstraint.activate([
            minValueLabel.topAnchor.constraint(equalTo: seekSlider.bottomAnchor),
            minValueLabel.leadingAnchor.constraint(equalTo: seekSlider.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            maxValueLabel.topAnchor.constraint(equalTo: seekSlider.bottomAnchor),
            maxValueLabel.trailingAnchor.constraint(equalTo: seekSlider.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: seekSlider.bottomAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 250.0),
            playButton.widthAnchor.constraint(equalToConstant: 250.0)
        ])
    }
    
    func updateUI(time: CMTime) {
        if !isSliderBeingTouched {
            seekSlider.value = Float(time.seconds)
        }
        minValueLabel.text = formatSecondsToMinutesSeconds(Int(time.seconds))
    }
    
    private func formatSecondsToMinutesSeconds(_ seconds: Int)-> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func allowSliderUpdate() {
        isSliderBeingTouched = false
    }
    
    @objc func seekSliderChanged(_ sender: UISlider) {
        delegate?.sliderValueChanged(to: sender.value)
        ///notes: updateUI를 통해 중복으로 seekSlider value가 업데이트 되는걸 방지하기 위해 0.1초 추가
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: DispatchWorkItem(block: {
            self.allowSliderUpdate()
        }))
    }
    
    @objc func togglePlayPause() {
        let image = isPlayButtonTouched ? playImage : pauseImage
        playButton.setImage(image, for: .normal)
        delegate?.togglePlayPause()
        isPlayButtonTouched.toggle()
    }
    
    @objc func sliderTouchDown(_ sender: UISlider) {
        isSliderBeingTouched = true
    }
}
