//
//  SceneDelegate.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let navigationController = UINavigationController()
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        ///note: 런치스크린을 강제로 2초동안 표출하기 위해 Main 스레드를 2초간 대기상태로 돌리는 코드
        Thread.sleep(forTimeInterval: 2.0)
        appFlowCoordinator?.start()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}

