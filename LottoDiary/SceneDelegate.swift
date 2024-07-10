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
        
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !isFirstLaunch {
            let repository = RealmRepository()
            let dummyDiary = Diary()
            dummyDiary.content = "안녕하세요. 로또일기 개발자입니다 ☺️\n 꾸준히 업데이트 해보겠습니다. 행운 가~득한 하루 되길 바랄게요."
            dummyDiary.imageName = "temporary"
            dummyDiary.date = Date()
            
            repository.create(diary: dummyDiary)
            
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
        }

        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .point
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        let vc1 = MainViewController()
        let vc2 = DiaryViewController()
//        let vc3 = ChartViewController()
        let vc4 = SettingViewController()
    
        vc1.tabBarItem = UITabBarItem(title: "로또", image: UIImage(named: "clover"), selectedImage: UIImage(named: "clover"))
        vc1.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 2, right: 0)

        vc1.tabBarItem.tag = 0
        vc2.tabBarItem = UITabBarItem(title: "일기", image: UIImage(named: "edit"), selectedImage: UIImage(named: "edit"))
        vc2.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 2, right: 0)

        vc2.tabBarItem.tag = 1
//        vc3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "stats"), selectedImage: UIImage(named: "stats"))
//        vc3.tabBarItem.tag = 2
        vc4.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "user"), selectedImage: UIImage(named: "user"))
        vc4.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 2, right: 0)

        vc4.tabBarItem.tag = 3
        
        
        // tabBarController.viewControllers = [vc1, vc2, vc3, vc4].map { UINavigationController(rootViewController: $0) }
        tabBarController.viewControllers = [vc1, vc2, vc4].map { UINavigationController(rootViewController: $0) }
        
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

extension UIImage
{
    func scale(newWidth: CGFloat) -> UIImage
    {
        guard self.size.width != newWidth else{return self}
        
        let scaleFactor = newWidth / self.size.width
        
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
