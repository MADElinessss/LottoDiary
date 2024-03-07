//
//  SceneDelegate.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        
        let vc1 = MainViewController()
        let vc2 = DiaryViewController()
        let vc3 = ChartViewController()
        let vc4 = SettingViewController()
        
        vc1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "sun.min"), selectedImage: UIImage(named: "sun.min.fill"))
        vc1.tabBarItem.tag = 0
        vc2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "moon"), selectedImage: UIImage(named: "moon.fill"))
        vc2.tabBarItem.tag = 1
        vc3.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "moon.stars"), selectedImage: UIImage(named: "moon.stars.fill"))
        vc3.tabBarItem.tag = 2
        vc4.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cloud"), selectedImage: UIImage(named: "cloudfill"))
        vc4.tabBarItem.tag = 3
        
        
        tabBarController.viewControllers = [vc1, vc2, vc3, vc4].map { UINavigationController(rootViewController: $0) }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

