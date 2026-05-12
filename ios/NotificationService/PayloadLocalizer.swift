//
//  PayloadLocalizer.swift
//  NotificationService
//
//  Pure translation logic mirroring `lib/features/notifications/data/notification_localizer.dart`.
//
//  Input: APNs/FCM `userInfo` dictionary containing:
//    - `title` (String) — translation key (e.g. `order.for_table`)
//    - `body`  (String or Dictionary) — interpolation values; when a String, must be a JSON object
//    - `type`, `entityId` — optional metadata (ignored for rendering)
//    - `locale` (String) — optional locale override sent by backend (e.g. `sr`, `en`)
//
//  Output: `LocalizedText` with translated title and optional body.
//
//  Locale resolution priority:
//    1. `userInfo["locale"]` (backend-provided)
//    2. iOS preferred languages matched against the bundle's supported set
//    3. English fallback

import Foundation

struct LocalizedText {
    let title: String
    let body: String?
}

final class PayloadLocalizer {

    static let shared = PayloadLocalizer()

    private static let supportedLocales: [String] = [
        "en", "sr", "de", "es", "fr", "hr", "hi", "it", "ru", "el", "mt", "ne",
    ]

    private init() {}

    func resolve(userInfo: [AnyHashable: Any]) -> LocalizedText? {
        guard let titleKey = stringValue(userInfo["title"]), !titleKey.isEmpty else {
            return nil
        }

        let body = parseBody(userInfo["body"])
        let localeCode = stringValue(userInfo["locale"])
        let bundle = resolveBundle(forLocale: localeCode)

        let title = resolveTitle(key: titleKey, values: body, bundle: bundle)
        let messageKey = stringValue(body["messageKey"])
        let resolvedBody: String?
        if let messageKey = messageKey, !messageKey.isEmpty {
            resolvedBody = resolveMessage(key: messageKey, values: body, bundle: bundle)
        } else {
            resolvedBody = resolveFallbackBody(titleKey: titleKey, values: body, bundle: bundle)
        }

        return LocalizedText(title: title, body: resolvedBody)
    }

    // MARK: - Title

    private func resolveTitle(
        key: String,
        values: [String: Any],
        bundle: Bundle
    ) -> String {
        switch key {
        case "order.for_table":
            return format("notificationOrderForTableTitle", bundle, s(values, "table"))
        case "order.kitchen_for_table":
            return format("notificationOrderKitchenForTableTitle", bundle, s(values, "table"))
        case "order.bar_for_table":
            return format("notificationOrderBarForTableTitle", bundle, s(values, "table"))
        case "order.rejected":
            return format("notificationOrderRejectedTitle", bundle, s(values, "orderNumber"))
        case "order.confirmed":
            return format("notificationOrderConfirmedTitle", bundle, s(values, "orderNumber"))
        case "order.completion_time":
            return localized("notificationOrderCompletionTimeTitle", bundle)
        case "order_item.rejected_title":
            return format("notificationOrderItemRejectedTitle", bundle, s(values, "productName"))
        case "order_item.rejected_waiter_title":
            return format("notificationOrderItemRejectedWaiterTitle", bundle, s(values, "table"))
        case "order_item.eta_title":
            return format("notificationOrderItemEtaTitle", bundle, s(values, "table"))
        case "order_item.accepted_title":
            return format("notificationOrderItemAcceptedTitle", bundle, s(values, "productName"))
        case "reservation.new_request":
            return localized("notificationReservationNewRequestTitle", bundle)
        case "reservation.confirmed":
            return format("notificationReservationConfirmedTitle", bundle, s(values, "reservationNumber"))
        case "reservation.rejected":
            return format("notificationReservationRejectedTitle", bundle, s(values, "reservationNumber"))
        case "reservation.cancelled":
            return format("notificationReservationCancelledTitle", bundle, s(values, "reservationNumber"))
        case "reservation_reminder.title":
            return localized("notificationReservationReminderTitle", bundle)
        case "kitchen.start_preparation_title":
            return localized("notificationKitchenStartPreparationTitle", bundle)
        case "food_ready.title":
            return format("notificationFoodReadyTitle", bundle, s(values, "table"))
        case "drinks_ready.title":
            return format("notificationDrinksReadyTitle", bundle, s(values, "table"))
        default:
            return key
        }
    }

    // MARK: - Body (messageKey path)

    private func resolveMessage(
        key: String,
        values: [String: Any],
        bundle: Bundle
    ) -> String? {
        switch key {
        case "order_item.rejected_customer_body":
            return format("notificationOrderItemRejectedCustomerBody", bundle, s(values, "productName"))
        case "order_item.rejected_waiter_body":
            return format("notificationOrderItemRejectedWaiterBody", bundle, s(values, "productName"))
        case "order_item.eta_body":
            return format(
                "notificationOrderItemEtaBody",
                bundle,
                s(values, "minutes"),
                s(values, "productName")
            )
        case "order_item.eta_body_no_time":
            return format("notificationOrderItemEtaBodyNoTime", bundle, s(values, "productName"))
        case "order_item.accepted_body":
            return format("notificationOrderItemAcceptedBody", bundle, s(values, "productName"))
        case "reservation_reminder.body":
            return localized("notificationReservationReminderBody", bundle)
        case "kitchen.start_preparation_body":
            return format(
                "notificationKitchenStartPreparationBody",
                bundle,
                s(values, "reservationNumber"),
                s(values, "time")
            )
        case "food_ready.body":
            return format("notificationFoodReadyBody", bundle, s(values, "items"))
        case "drinks_ready.body":
            return format("notificationDrinksReadyBody", bundle, s(values, "items"))
        default:
            return fallbackBody(values)
        }
    }

    // MARK: - Body (title-based fallback)

    private func resolveFallbackBody(
        titleKey: String,
        values: [String: Any],
        bundle: Bundle
    ) -> String? {
        switch titleKey {
        case "order.for_table":
            return format("notificationOrderForTableBody", bundle, s(values, "items"))
        case "order.kitchen_for_table":
            return format("notificationOrderKitchenForTableBody", bundle, s(values, "items"))
        case "order.bar_for_table":
            return format("notificationOrderBarForTableBody", bundle, s(values, "items"))
        case "order.rejected":
            return format(
                "notificationOrderRejectedBody",
                bundle,
                s(values, "table"),
                s(values, "rejectionNote")
            )
        case "order.confirmed":
            return format(
                "notificationOrderConfirmedBody",
                bundle,
                s(values, "table"),
                s(values, "venueName")
            )
        case "order.completion_time":
            return format("notificationOrderCompletionTimeBody", bundle, s(values, "time"))
        case "reservation.new_request":
            return format(
                "notificationReservationNewRequestBody",
                bundle,
                s(values, "people"),
                s(values, "time"),
                s(values, "table")
            )
        case "reservation.confirmed":
            return format(
                "notificationReservationConfirmedBody",
                bundle,
                s(values, "table"),
                s(values, "venueName")
            )
        case "reservation.rejected":
            return format("notificationReservationRejectedBody", bundle, s(values, "reason"))
        case "reservation.cancelled":
            return format("notificationReservationCancelledBody", bundle, s(values, "venueName"))
        default:
            return fallbackBody(values)
        }
    }

    // MARK: - Helpers

    private func fallbackBody(_ values: [String: Any]) -> String? {
        if let message = values["message"] as? String, !message.isEmpty {
            return message
        }
        if let items = values["items"] as? [Any], !items.isEmpty {
            return items.map(formatValue).joined(separator: ", ")
        }
        return nil
    }

    private func s(_ values: [String: Any], _ key: String) -> String {
        guard let value = values[key] else { return "" }
        if let array = value as? [Any] {
            return array.map(formatValue).joined(separator: ", ")
        }
        if key == "time", let str = value as? String {
            return formatTime(str)
        }
        return formatValue(value)
    }

    private static let isoFormatters: [ISO8601DateFormatter] = {
        let withFraction = ISO8601DateFormatter()
        withFraction.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let standard = ISO8601DateFormatter()
        standard.formatOptions = [.withInternetDateTime]
        return [withFraction, standard]
    }()

    private static let localTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()

    /// Converts ISO-8601 strings (e.g. `2025-06-15T19:00:00.000Z`) into the
    /// device's local `HH:mm`. Non-ISO values pass through unchanged.
    private func formatTime(_ value: String) -> String {
        for formatter in Self.isoFormatters {
            if let date = formatter.date(from: value) {
                return Self.localTimeFormatter.string(from: date)
            }
        }
        return value
    }

    private func formatValue(_ value: Any) -> String {
        if let dict = value as? [String: Any] {
            let productName = dict["productName"]
            let quantity = dict["quantity"]
            if let productName = productName, let quantity = quantity {
                return "\(quantity)x \(productName)"
            }
            if let productName = productName {
                return "\(productName)"
            }
        }
        if let number = value as? NSNumber {
            return number.stringValue
        }
        return String(describing: value)
    }

    private func parseBody(_ raw: Any?) -> [String: Any] {
        if let dict = raw as? [String: Any] {
            return dict
        }
        if let dict = raw as? NSDictionary {
            var result: [String: Any] = [:]
            for (key, value) in dict {
                if let key = key as? String {
                    result[key] = value
                }
            }
            return result
        }
        if let string = raw as? String,
           let data = string.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                if let dict = json as? [String: Any] {
                    return dict
                }
            } catch {
                return ["message": string]
            }
        }
        return [:]
    }

    private func stringValue(_ raw: Any?) -> String? {
        if let value = raw as? String { return value }
        if let value = raw as? NSNumber { return value.stringValue }
        return nil
    }

    // MARK: - Bundle / locale resolution

    private func resolveBundle(forLocale localeCode: String?) -> Bundle {
        let base = Bundle.main

        if let lc = localeCode, !lc.isEmpty,
           let path = base.path(forResource: lc, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }

        let preferred = Bundle.preferredLocalizations(from: Self.supportedLocales)
        for code in preferred {
            if let path = base.path(forResource: code, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                return bundle
            }
        }

        if let path = base.path(forResource: "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }

        return base
    }

    private func localized(_ key: String, _ bundle: Bundle) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: "")
    }

    private func format(_ key: String, _ bundle: Bundle, _ args: CVarArg...) -> String {
        let template = localized(key, bundle)
        return String(format: template, arguments: args)
    }
}
