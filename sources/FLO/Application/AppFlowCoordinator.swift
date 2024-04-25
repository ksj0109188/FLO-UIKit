//
//  AppFlowCoordinator.swift
//  FLO
//
//  Created by 김성준 on 4/24/24.
//

import UIKit

///note: FlowCoordinator들을 관리역할
final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    ///note: 앱 런치시 플로우 시작 메소드로, 런타임 시점에 실행될 흐름 추가 만약 로그인시 다른 화면의 흐름이 필요하다면, start 메소드 내 새로운 FlowCoordinator를 start
    func start() {
        let playSongSceneDIContainer = appDIContainer.makePlaySongSceneDIContainer()
        let flow = playSongSceneDIContainer.makePlaySongFlowCoordinator(navigationController: navigationController)
        
        flow.start()
    }
}
