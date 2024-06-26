//
//  APDetailingApp.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import Firebase
import UIKit

@main
struct APDetailingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var loadingHelper = LoadingViewHelper.shared
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@MainActor class LoadingViewHelper: ObservableObject {
    static var shared = LoadingViewHelper()
    @Published var isShowingLaunchScreen = true
    @Published var isShowingLoadingIndicator = false
    
    private init() {}
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { _,_ in })
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        Task { DetailMenu.shared.fetchMenu() }
        Task {
            await Networking.getAdminInfo()
            User.shared.login()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        return [[.banner, .list, .sound, .badge]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let apptID = userInfo["apptID"] as? String {
            DeepLinkRouter.shared.deepLinkView = .appointment(id: apptID)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {}
}


