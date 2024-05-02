//
//  PlaySongSceneDIContainer.swift
//  FLO
//
//  Created by 김성준 on 4/23/24.
//

import UIKit
import AVKit

final class PlaySongSceneDIContainer: PlaySongFlowCoordinatorDependencies {
    struct Dependencies {
        // MARK: API Service
        let realSongWebRepository: RealSongWebRepository
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Use Cases
    private func makeFetchSongUseCase() -> FetchSongUseCase {
        FetchSongUseCase(songWebRepository: dependencies.realSongWebRepository)
    }
    
    // MARK: PlaySongScene
    ///note: PlayerManager의 경우 별도의 의존성 주입이 필요하다면 PlaySongSceneDIContainer에서 메소드 생성 후 의존성 주입
    private func makePlaySongSceneViewModel(actions: PlaySongSceneViewModelActions) -> PlaySongSceneViewModel {
        return PlaySongSceneViewModel(fetchSongUseCase: makeFetchSongUseCase(), playerManager: PlayerManager(), actions: actions)
    }
    
    func makeDetailLyricsTableViewModel(songDTO: SongDTO, playerManager: PlayerManager) -> DetailLyricsViewModel {
        return DetailLyricsViewModel(songDTO: songDTO, playerManger: playerManager)
    }
    
    // MARK: Presentation
    func makePlaySongSceneViewController(actions: PlaySongSceneViewModelActions) -> PlaySongSceneViewController {
        let vc = PlaySongSceneViewController()
        vc.create(viewModel: makePlaySongSceneViewModel(actions: actions))
        
        return vc
    }
    
    func makeDetailLyricsTableViewController(songDTO: SongDTO, playerManager: PlayerManager) -> DetailLyricsTableViewController {
        let vc = DetailLyricsTableViewController()
        vc.create(viewModel: makeDetailLyricsTableViewModel(songDTO: songDTO, playerManager: playerManager))
        
        return vc
    }
    
    func makePlaySongFlowCoordinator(navigationController: UINavigationController) -> PlaySongFlowCoordinator {
        PlaySongFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
}
