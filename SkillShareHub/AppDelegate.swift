//
//  AppDelegate.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 09/02/2024.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseSessions
import FirebaseFirestore
import FirebaseDatabase
import FirebaseFunctions
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebasePerformance
import StreamChat

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var chatClient:ChatClient!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        var config = ChatClientConfig(apiKeyString: "tskz3baqm26v")
        chatClient = ChatClient(config:config)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension ChatClient {
    static var shared: ChatClient!
}

