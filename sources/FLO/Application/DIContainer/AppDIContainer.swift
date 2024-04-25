//
//  AppDIContainer.swift
//  FLO
//
//  Created by 김성준 on 4/21/24.
//

import Foundation

///note: central unit으로 각 화면별 FlowCoordinator의 DIContainer 의존성 주입 담당
final class AppDIContainer {
    lazy var appConfigurations = AppConfigurations()
    
    lazy var realSongWebRepository: RealSongWebRepository = {
        let config = AppConfigurations()
        return RealSongWebRepository(config: config)
    }()
    
    func makePlaySongSceneDIContainer() -> PlaySongSceneDIContainer {
        let dependencies = PlaySongSceneDIContainer.Dependencies(
            realSongWebRepository: realSongWebRepository)
        
        return PlaySongSceneDIContainer(dependencies: dependencies)
    }
    
}
