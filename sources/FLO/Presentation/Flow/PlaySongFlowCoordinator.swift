//
//  Coordinator.swift
//  FLO
//
//  Created by 김성준 on 4/23/24.
//

import UIKit

///note: PlaySongSceneDIContainer에서 PlaySongFlowCoordinator에 정의한 화면 전환시 의존성 주입 메소드 리스트
protocol PlaySongFlowCoordinatorDependencies {
    func makeDetailLyricsTableViewController(songDTO: SongDTO, playerManager: PlayerManager) -> DetailLyricsTableViewController
    func makePlaySongSceneViewController(actions: PlaySongSceneViewModelActions) -> PlaySongSceneViewController
}

///note: 노래재생 화면의 흐름을 제어하기 위한 Coordinator
final class PlaySongFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: PlaySongFlowCoordinatorDependencies
    
    private weak var playSongSceneViewController: PlaySongSceneViewController?
    
    init(navigationController: UINavigationController, dependencies: PlaySongFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = PlaySongSceneViewModelActions(showDetailLyrics: showDetailLyrics)
        let vc = dependencies.makePlaySongSceneViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        
        playSongSceneViewController = vc
    }
    
    private func showDetailLyrics(songDTO: SongDTO, playerManager: PlayerManager) {
        let vc = dependencies.makeDetailLyricsTableViewController(songDTO: songDTO, playerManager: playerManager)
        
        navigationController?.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true)
    }
    
    
}
