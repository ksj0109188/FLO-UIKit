//
//  DetailLyricsSceneViewController.swift
//  FLO
//
//  Created by 김성준 on 5/2/24.
//

import UIKit
import AVKit

protocol DetailLyricsSceneViewControllerDelegate: AnyObject {
    func dismiss()
}

final class DetailLyricsSceneViewController: UIViewController {
   
    //TODO: private viewModel create함수 처럼 내부 함수로 설정하도록 변경하기
    var viewModel: DetailLyricsViewModel!
    
    private lazy var detailLyricsTableView: DetailLyricsTableViewController = {
        let tableView = DetailLyricsTableViewController()
        tableView.config(viewModel: viewModel)
        tableView.delegate = self
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var detailLyricsSceneNavigationBar: DetailLyricsSceneNavigationBar = {
        let view = DetailLyricsSceneNavigationBar()
        view.configure(with: viewModel.songDTO)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playControlView: PlayControlView = {
        let view = PlayControlView()
        view.delegate = self
        viewModel.playerManager.observer { time in
            view.updateUI(time: time)
        }
        view.configure(with: viewModel.songDTO)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func create(viewModel: DetailLyricsViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        self.navigationController?.isNavigationBarHidden = true
        
        addChild(detailLyricsTableView)
        view.addSubviews(
            detailLyricsSceneNavigationBar,
            detailLyricsTableView.view,
            playControlView
        )
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            detailLyricsSceneNavigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailLyricsSceneNavigationBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailLyricsSceneNavigationBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailLyricsSceneNavigationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            detailLyricsTableView.view.topAnchor.constraint(equalTo: detailLyricsSceneNavigationBar.bottomAnchor),
            detailLyricsTableView.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailLyricsTableView.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            detailLyricsTableView.view.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            playControlView.topAnchor.constraint(equalTo: detailLyricsTableView.view.bottomAnchor),
            playControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playControlView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            playControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension DetailLyricsSceneViewController: DetailLyricsSceneViewControllerDelegate {
    func dismiss() {
        viewModel.dismissDetailLyricsView()
    }
}

extension DetailLyricsSceneViewController: PlayControlDelegate {
    func togglePlayPause() {
        viewModel.playerManager.pausePlayer()
    }
    
    func sliderValueChanged(to value: Float) {
        let targetTime = CMTimeMake(value: Int64(value), timescale: 1)
        viewModel.playerManager.moveToTimeLine(to: targetTime)
    }
}
