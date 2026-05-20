import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let notificationLaunchChannelName =
    "zadana_delivery/notification_launch"
  private var pendingNotificationPayload: [String: Any]?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self

    if let remoteNotification =
      launchOptions?[.remoteNotification] as? [AnyHashable: Any]
    {
      pendingNotificationPayload = normalizeDictionary(remoteNotification)
    }

    GeneratedPluginRegistrant.register(with: self)
    let didFinish = super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: notificationLaunchChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        guard let self else {
          result([String: Any]())
          return
        }

        switch call.method {
        case "consumePendingPayload":
          result(self.pendingNotificationPayload ?? [String: Any]())
          self.pendingNotificationPayload = nil
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return didFinish
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    pendingNotificationPayload = normalizeDictionary(
      response.notification.request.content.userInfo
    )
    completionHandler()
  }

  private func normalizeDictionary(_ dictionary: [AnyHashable: Any]) -> [String: Any] {
    var normalized: [String: Any] = [:]
    for (key, value) in dictionary {
      normalized[String(describing: key)] = normalizeValue(value)
    }
    return normalized
  }

  private func normalizeValue(_ value: Any) -> Any {
    if let dictionary = value as? [AnyHashable: Any] {
      return normalizeDictionary(dictionary)
    }
    if let array = value as? [Any] {
      return array.map(normalizeValue)
    }
    return value
  }
}
