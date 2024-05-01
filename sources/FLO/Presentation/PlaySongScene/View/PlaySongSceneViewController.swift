//
//  ViewController.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import UIKit
import AVKit
import Combine

protocol PlayControlDelegate: AnyObject {
    func togglePlayPause()
    func sliderValueChanged(to value: Float)
}

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
            .sink(receiveValue: {
                view.configure(with: $0)
            })
            .store(in: &subscriptions)
        return view
    }()
    
    private lazy var playControlView: PlayControlView = {
        let view = PlayControlView()
        view.delegate = self
        view.viewModel = viewModel
        viewModel.songSubject
            .sink(receiveValue: {
                view.configure(with: $0)
            })
            .store(in: &subscriptions)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var lyricsView: PlayLyricsView = {
        let view = PlayLyricsView()
        view.viewModel = viewModel
        viewModel.songSubject
            .sink(receiveValue: {
                view.configure(with: $0)
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
            playControlView.topAnchor.constraint(equalTo: lyricsView.bottomAnchor, constant: padding),
            playControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            playControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playControlView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            playControlView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5)
        ])
    }
    
    //TODO: FlowCoordinator로 흐름 이동 필요
    @objc func showDetailLyricsView() {
        let viewController = DetailLyricsTableViewController()
        viewController.playerManger = viewModel?.playerManger
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: false)
    }
    
}

extension PlaySongSceneViewController: PlayControlDelegate {
    func togglePlayPause() {
        viewModel.playerManger.pausePlayer()
    }
    
    func sliderValueChanged(to value: Float) {
        let targetTime = CMTimeMake(value: Int64(value), timescale: 1)
        viewModel.playerManger.moveToTimeLine(to: targetTime)
    }
    
}
