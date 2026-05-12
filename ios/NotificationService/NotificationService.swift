//
//  NotificationService.swift
//  NotificationService
//
//  Intercepts incoming pushes (requires APNs `mutable-content: 1`) and
//  replaces the system-shown title/body with localized strings using the
//  extension's own `Localizable.strings` resources.
//
//  The translation logic mirrors `NotificationLocalizer` in Dart so that
//  iOS background/killed notifications look identical to foreground ones
//  rendered through `flutter_local_notifications`.
//

import UserNotifications

final class NotificationService: UNNotificationServiceExtension {

    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent

        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }

        let userInfo = bestAttemptContent.userInfo

        if let resolved = PayloadLocalizer.shared.resolve(userInfo: userInfo) {
            bestAttemptContent.title = resolved.title
            if let body = resolved.body {
                bestAttemptContent.body = body
            }
        }

        contentHandler(bestAttemptContent)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
