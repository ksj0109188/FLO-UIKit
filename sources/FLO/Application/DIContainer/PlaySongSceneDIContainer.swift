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
        let realSongWebRepository: RealSongWebRepository
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeDetailLyricsTableViewController() -> DetailLyricsTableViewController {
        DetailLyricsTableViewController()
    }
    
    func makePlaySongSceneViewController() -> PlaySongSceneViewController {
        PlaySongSceneViewController()
    }
    
    func makePlaySongFlowCoordinator(navigationController: UINavigationController) -> PlaySongFlowCoordinator {
        PlaySongFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
}
