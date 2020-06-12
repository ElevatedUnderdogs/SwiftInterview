//
//  UNNotificationCategory.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UserNotifications

public extension UNNotificationCategory {
    class func newCategory(
        actions: [UNNotificationAction],
        identifier: String =  "newCategoryIdentifier"
        ) -> UNNotificationCategory {
        
        return UNNotificationCategory(
            identifier: identifier,
            actions: actions,
            intentIdentifiers: [],
            options: []
        )
    }
}
