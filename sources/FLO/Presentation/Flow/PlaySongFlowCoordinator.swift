//
//  Coordinator.swift
//  FLO
//
//  Created by 김성준 on 4/23/24.
//

import UIKit

///note: PlaySongSceneDIContainer에서 PlaySongFlowCoordinator에 정의한 화면 전환시 의존성 주입 메소드 리스트
protocol PlaySongFlowCoordinatorDependencies {
    func makeDetailLyricsSceneViewController(songDTO: SongDTO, playerManager: PlayerManager, actions: DetailLyricsViewModelActions) -> DetailLyricsSceneViewController
    func makePlaySongSceneViewController(actions: PlaySongSceneViewModelActions) -> PlaySongSceneViewController
}

///note: 노래재생 화면의 흐름을 제어하기 위한 Coordinator
final class PlaySongFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: PlaySongFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: PlaySongFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = PlaySongSceneViewModelActions(showDetailLyrics: showDetailLyrics)
        let vc = dependencies.makePlaySongSceneViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showDetailLyrics(songDTO: SongDTO, playerManager: PlayerManager) {
        let actions = DetailLyricsViewModelActions(dismissDetailLyricsView: dismissDetailLyricsView)
        let vc = dependencies.makeDetailLyricsSceneViewController(songDTO: songDTO, playerManager: playerManager, actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func dismissDetailLyricsView() {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
