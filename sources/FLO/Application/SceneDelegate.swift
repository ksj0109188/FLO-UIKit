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
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        let navigationController = UINavigationController()
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.start()
        
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}

