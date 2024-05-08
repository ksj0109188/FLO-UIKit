//
//  ViewController.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import UIKit
import AVKit
import Combine

final class PlaySongSceneViewController: UIViewController {
    private var subscriptions =  Set<AnyCancellable>()
    private var viewModel: PlaySongSceneViewModel!
    
    func create(viewModel: PlaySongSceneViewModel) {
        self.viewModel = viewModel
    }
    
    private lazy var playInfoView: PlayInfoView = {
        let view = PlayInfoView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.songSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                view.configure(with: $0)
            })
            .store(in: &subscriptions)
        
        return view
    }()
    
    private lazy var playControlView: PlayControlView = {
        let playerManager = viewModel.playerManager
        let view = PlayControlView()

        view.delegate = self
        viewModel.songSubject
            .sink(receiveValue: {
                view.configure(with: $0, playerPuasedObserver: playerManager.isPausedSubject, time: playerManager.playerTime())
                playerManager.observer { time in
                    view.updateUI(time: time)
                }
            })
            .store(in: &subscriptions)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var lyricsView: PlayLyricsView = {
        let view = PlayLyricsView()
        
        viewModel.songSubject
            .sink(receiveValue: {
                view.configure(with: $0, viewModel: self.viewModel)
            })
            .store(in: &subscriptions)
        
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
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            playInfoView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding),
            playInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            playInfoView.heightAnchor.constraint(equalToConstant: viewFrame.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            lyricsView.topAnchor.constraint(equalTo: playInfoView.bottomAnchor, constant: padding),
            lyricsView.leadingAnchor.constraint(equalTo: playInfoView.leadingAnchor),
            lyricsView.trailingAnchor.constraint(equalTo: playInfoView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            playControlView.topAnchor.constraint(equalTo: lyricsView.bottomAnchor, constant: padding),
            playControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            playControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playControlView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    @objc func showDetailLyricsView() {
        viewModel.showDetailLyrics()
    }
    
}

extension PlaySongSceneViewController: PlayControlDelegate {
    func togglePlayPause() {
        viewModel.playerManager.togglePlayPause()
    }
    
    func sliderValueChanged(to value: Float) {
        let targetTime = CMTimeMake(value: Int64(value), timescale: 1)
        viewModel.playerManager.moveToTimeLine(to: targetTime)
    }
    
}
