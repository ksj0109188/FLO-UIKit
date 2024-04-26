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
    func makeFetchSongUseCase() -> FetchSongUseCase {
        FetchSongUseCase(songWebRepository: dependencies.realSongWebRepository)
    }
    
    // MARK: PlaySongScene
    func makePlaySongSceneViewModel() -> PlaySongSceneViewModel {
        PlaySongSceneViewModel(fetchSongUseCase: makeFetchSongUseCase())
    }
    
    // MARK: Presentation
    func makePlaySongSceneViewController() -> PlaySongSceneViewController {
        let vc = PlaySongSceneViewController()
        vc.create(viewModel: makePlaySongSceneViewModel())
        
        return vc
    }
    
    func makeDetailLyricsTableViewController() -> DetailLyricsTableViewController {
        DetailLyricsTableViewController()
    }
    
    func makePlaySongFlowCoordinator(navigationController: UINavigationController) -> PlaySongFlowCoordinator {
        PlaySongFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
}
