//
//  FirebaseManager.swift
//  DigitalVelocity
//
//  Created by Tealium User on 5/9/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import UserNotifications

typealias FirebaseManagerErrorBlock = (_ error: Error)->()
typealias FirebaseManagerNotificationBlock = (_ notification: Notification)->()

enum FirebaseManagerError: Error {
    case couldNotConvertSavedDataToNotificationObjects
    case couldNotConvertUserInfoToJsonString
    case couldNotConvertUserInfoToJsonData
    case couldNotDecodeUserInfoToNotificationObject
    case couldNotEncodeNotifications
    case couldNotSaveNotifications
}

class FirebaseManager: BaseManager {
    
    static let shared = FirebaseManager()
    static let filename = "firebaseNotifications"

    var didStart = false
    var errorBlock: FirebaseManagerErrorBlock?
    var notificationBlock: FirebaseManagerNotificationBlock?
    var notifications: [Notification] = []
    
    var db : Firestore?
    
    func start(_ completion: @escaping ()->()) {
        
        if didStart == true { return }
        
        FirebaseApp.configure()
        db = Firestore.firestore()
        if let settings = db?.settings {
            settings.areTimestampsInSnapshotsEnabled = true
            db?.settings = settings
        }
        
//        Messaging.messaging().delegate = self
        
//        notifications = loadNotifications()
        
//        let application = UIApplication.shared
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        
        didStart = true
        completion()
    }
    
//    func loadNotifications() -> [Notification] {
//        guard let data = Persistence.loadData(filename: FirebaseManager.filename) else {
//            // No prior saved data
//            return []
//        }
//        guard let notifications = try? JSONDecoder().decode([Notification].self, from: data) else {
//            errorBlock?(FirebaseManagerError.couldNotConvertSavedDataToNotificationObjects)
//            return []
//        }
//        return notifications
//    }
//
//    func saveNotifications(_ notifications: [Notification]) {
//        guard let data = try? JSONEncoder().encode(notifications) else {
//            errorBlock?(FirebaseManagerError.couldNotEncodeNotifications)
//            return
//        }
//        if Persistence.saveData(data, filename: FirebaseManager.filename) == false {
//            errorBlock?(FirebaseManagerError.couldNotSaveNotifications)
//        }
//    }
    
//    func setDeviceToken(_ data: Data){
//        Messaging.messaging().apnsToken = data
//        Messaging.messaging().subscribe(toTopic: "all")
//    }
    
    func onError(_ completion: @escaping FirebaseManagerErrorBlock) {
        errorBlock = completion
    }
    
    func onNotificationReceived(_ completion: @escaping FirebaseManagerNotificationBlock) {
        notificationBlock = completion
    }
}

//extension FirebaseManager : UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
////        Log.debug("Response: \(response)")
//
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
////        Log.debug("Notification: \(notification)")
////        Log.debug("Notification: \(notification.request.content.userInfo as AnyObject)")
//        let info = notification.request.content.userInfo
//        do {
//            let data = try JSONSerialization.data(withJSONObject: info, options: [])
//            let aNotification = try JSONDecoder().decode(Notification.self, from: data)
//            notifications.append(aNotification)
//            saveNotifications(notifications)
//            notificationBlock?(aNotification)
//        } catch let e {
////            Log.error(e)
//            errorBlock?(FirebaseManagerError.couldNotDecodeUserInfoToNotificationObject)
//            return
//        }
//
//    }
//}

//extension FirebaseManager : MessagingDelegate {
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        Log.debug("FCMToken: \(fcmToken)")
//    }
//}
