//
//  SmartHomeAppApp.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI
import Firebase
//import FirebaseCore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct SmartHomeAppApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        FirebaseApp.configure()
        // Initialize ConfigManager
        let _ = ConfigManager.shared // Ensure ConfigManager is initialized
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
