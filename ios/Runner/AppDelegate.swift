import UIKit
import Flutter
import GoogleMaps
import Firebase
import Foundation
import UserNotifications

enum Test: String {
    case SHOW = "show"
}

struct MethodChannelMethods {
    static let SHOW = "show"
}
struct MethodChannelChannels {
    static let CHANNEL_NOTIFICATION = "nameum/notification"
}
struct NotificationInfo {
    static let ON_CLICK_EVENT_TYPE = "on_click_event_type"
    static let STORE_ID = "store_id"
    static let NOTIFICATION_INFO = "notification_info"
}
struct NotificationEvents {
    static let RESERVE_ACCEPTED_NOTIFICATION_CLICKED = "RESERVE_ACCEPTED_NOTIFICATION_CLICKED"
    static let RESERVE_ACCEPTED = "reserve_accepted"
    static let EVENT_TO_EVENT = [RESERVE_ACCEPTED : RESERVE_ACCEPTED_NOTIFICATION_CLICKED]
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // Foreground Notification
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // On tap notification
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let data = response.notification.request.content
        var method: String = ""
        var beSentArg: [String: Any] = [:]
        let onClickType = String(describing:data.userInfo[NotificationInfo.ON_CLICK_EVENT_TYPE]!)
        switch onClickType {
            case NotificationEvents.RESERVE_ACCEPTED:
                beSentArg[NotificationInfo.STORE_ID] = data.userInfo[NotificationInfo.STORE_ID]
                method = NotificationEvents.RESERVE_ACCEPTED_NOTIFICATION_CLICKED
            default:
                break
        }
        
        FlutterMethodChannel(name: MethodChannelChannels.CHANNEL_NOTIFICATION, binaryMessenger: (window?.rootViewController as! FlutterViewController).binaryMessenger).invokeMethod(method, arguments: beSentArg)
            
        completionHandler()
    }
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let notificationChannel = FlutterMethodChannel(name: "nameum/notification",
                                                        binaryMessenger: controller.binaryMessenger)
        notificationChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            let manager = LocalNotificationManager()
            
            // Notification data
            let data = call.arguments as? [String: Any]
            guard data != nil else {return}
            
            switch call.method {
            case MethodChannelMethods.SHOW:
                manager.requestPermission()
                manager.addNotification(data: data!)
                manager.schedule()
            default:
                break
            }
        })
        
        let GMS_API_KEY = Bundle.main.GMSApiKey
        GMSServices.provideAPIKey(GMS_API_KEY)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
