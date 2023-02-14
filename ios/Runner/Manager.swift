import Foundation
import UserNotifications

// Features every notificaiton has
struct NotificationDetail {
    var id: String
    var title: String
    var body: String
    var sound: UNNotificationSound = UNNotificationSound.default
    var subtitle: String
    var summaryArgumentCount: Int?
    var summaryArgument: String?
    var notificationInfo: ReserveNotification
}
enum NotificationMajorType: String {
    case reserve
}
enum ReserveNotificationType: String {
    case reserve_accepted
    case reserve_rejected
    case reserve_complete
}
protocol NotificationBase {
    var majorType: NotificationMajorType {get}
}

class ReserveNotification {
    var storeId: String
    var onClickEventType: ReserveNotificationType
    var majorType: NotificationMajorType
    
    init(storeId: String, onClickEventType: ReserveNotificationType, majorType: NotificationMajorType) {
        self.storeId = storeId
        self.onClickEventType = onClickEventType
        self.majorType = majorType
    }
}

class LocalNotificationManager {

    var notifications = [NotificationDetail]()
    
    // Get proper NotificationBase class by major type of notification
    private func getNotificationClass(data: Dictionary<String, Any>) -> ReserveNotification? {

        let info = data["notification_info"] as! Dictionary<String, Any>
        let majorType = NotificationMajorType(rawValue: String(describing: info["major_type"]!))!
        let onClickEventType = ReserveNotificationType(rawValue: String(describing: info["on_click_event_type"]!))!
        
        switch majorType {
        case NotificationMajorType.reserve:
            return ReserveNotification(
                storeId: String(describing: info["store_id"]!),
                onClickEventType: onClickEventType,
                majorType: NotificationMajorType.reserve)
        default: break
        }
        return nil
    }
    
    // Convert sound property that defined as String to UNNotificationSound
    private func soundToSound(sound: String?) -> UNNotificationSound {
        switch sound {
        case "default":
            return UNNotificationSound.default
        case "critical":
            if #available(iOS 12.0, *) {
                return UNNotificationSound.defaultCritical
            }
        case "rington":
            if #available(iOS 15.2, *) {
                return UNNotificationSound.defaultRingtone
            }
        default:
            return UNNotificationSound.default
        }
        return UNNotificationSound.default
    }
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options:[.alert, .sound, .badge]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications()
                }
            }
    }
    func addNotification(data: Dictionary<String, Any>) -> Void {
        let notificationInfo = getNotificationClass(data: data)
        notifications.append(
            NotificationDetail(
                id: UUID().uuidString,
                title: data["title"] as! String,
                body: data["body"] as! String,
                sound: soundToSound(sound: data["sound"] as? String),
                subtitle: data["subtitle"] as? String ?? "",
                summaryArgumentCount: data["summaryArgumentCount"] as? Int,
                summaryArgument: data["summaryArgumentCount"] as? String,
                notificationInfo: notificationInfo!
            ))
    }
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            print(notification.notificationInfo.onClickEventType)
            print(type(of: notification.notificationInfo.onClickEventType))
            content.userInfo = [NotificationInfo.ON_CLICK_EVENT_TYPE: notification.notificationInfo.onClickEventType.rawValue,
                                NotificationInfo.STORE_ID: notification.notificationInfo.storeId
            ] as [String:Any]
            content.title = notification.title
            content.sound = notification.sound
            content.subtitle = notification.subtitle
            content.body = notification.body
            content.badge = 3
            
            if #available(iOS 12.0, *) {
                if notification.summaryArgumentCount != nil {content.summaryArgumentCount = notification.summaryArgumentCount!}
                if notification.summaryArgument != nil {content.summaryArgument = notification.summaryArgument!}
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) {error in
                guard error == nil else {return}
                print("Scheduling notification with id:")
            }
        }
    }
}
