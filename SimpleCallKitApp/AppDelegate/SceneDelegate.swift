//
//  SceneDelegate.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 10.12.23..
//

import UIKit
import CallKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        let navigationController = UINavigationController(rootViewController: CallViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


