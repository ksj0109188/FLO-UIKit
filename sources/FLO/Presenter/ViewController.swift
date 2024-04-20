//
//  ViewController.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import UIKit
import AVKit

protocol PlayControlDelegate: AnyObject {
    func togglePlayPause()
    func sliderValueChanged(to value: Float)
}

final class ViewController: UIViewController {
    
    private var playerManger = PlayerManager()
    
    private lazy var playInfoView: PlayInfoView = {
        let view = PlayInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playControlView: PlayControlView = {
        let view = PlayControlView()
        view.delegate = self
        view.playerManger = playerManger
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var lyricsView: LyricsView = {
        let view = LyricsView()
        view.playerManger = playerManger
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDetailLyricsView))
        view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubviews(playInfoView, lyricsView, playControlView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let viewFrame = view.bounds
        
        NSLayoutConstraint.activate([
            playInfoView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            playInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            playInfoView.widthAnchor.constraint(equalToConstant: viewFrame.width),
            playInfoView.heightAnchor.constraint(equalToConstant: viewFrame.height / 2)
        ])
        
        NSLayoutConstraint.activate([
            lyricsView.topAnchor.constraint(equalTo: playInfoView.bottomAnchor),
            lyricsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            lyricsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            lyricsView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            lyricsView.heightAnchor.constraint(equalToConstant: viewFrame.height / 2)
        ])
        
        NSLayoutConstraint.activate([
            playControlView.topAnchor.constraint(equalTo: lyricsView.bottomAnchor),
            playControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            playControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playControlView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            playControlView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5)
        ])
    }
    
    @objc func showDetailLyricsView() {
        let viewController = DetailLyricsViewController()
        viewController.playerManger = playerManger
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: false)
    }
    
}

extension ViewController: PlayControlDelegate {
    func togglePlayPause() {
        playerManger.player.rate == 0 ? playerManger.player.play() : playerManger.player.pause()
    }
    
    func sliderValueChanged(to value: Float) {
        let targetTime = CMTimeMake(value: Int64(value), timescale: 1)
        playerManger.player.seek(to: targetTime)
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}
