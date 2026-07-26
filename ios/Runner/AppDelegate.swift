import Flutter
import UIKit
import UserNotifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let notificationLaunchChannelName =
    "zadana_delivery/notification_launch"
  private let nativeNotificationsChannelName =
    "zadana_delivery/native_notifications"
  private var pendingNotificationPayload: [String: Any]?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA1XNcpZlXAgDtKVmC3vMi_V4_f3O4tLes")
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
      let launchChannel = FlutterMethodChannel(
        name: notificationLaunchChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      launchChannel.setMethodCallHandler { [weak self] call, result in
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

      let nativeNotificationsChannel = FlutterMethodChannel(
        name: nativeNotificationsChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      nativeNotificationsChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "registerForRemoteNotifications":
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
          result(true)
        case "installNativeForegroundFallback":
          result(false)
        case "consumeOfferPushTimestamp":
          result(0)
        case "consumePendingNotificationAction":
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return didFinish
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    NSLog("[ZadanaDelivery] APNs device token registered: %@", token)
    super.application(
      application,
      didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
    )
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog(
      "[ZadanaDelivery] APNs registration failed: %@",
      String(describing: error)
    )
    super.application(
      application,
      didFailToRegisterForRemoteNotificationsWithError: error
    )
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
