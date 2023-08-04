//
//  NotificationDelegate.swift
//  eDay2_1
//
//  Created by 杨东举 on 2022/1/23.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject,ObservableObject,UNUserNotificationCenterDelegate {


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.banner,.sound])
    }


}
