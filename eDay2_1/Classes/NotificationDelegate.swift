//
//  NotificationDelegate.swift
//  eDay2_1
//
//.
//

import SwiftUI
import UserNotifications

/// A delegate class that handles notification-related events when the app is in the foreground.
class NotificationDelegate: NSObject,ObservableObject,UNUserNotificationCenterDelegate {

    /// Determines how to present a notification when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.banner,.sound])
    }


}
