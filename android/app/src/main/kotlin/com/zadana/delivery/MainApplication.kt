package com.zadana.delivery

import android.app.Application
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import com.onesignal.OneSignal
import com.onesignal.notifications.INotificationLifecycleListener
import com.onesignal.notifications.INotificationWillDisplayEvent

class MainApplication : Application() {
    private val foregroundFallbackListener =
        object : INotificationLifecycleListener {
            override fun onWillDisplay(event: INotificationWillDisplayEvent) {
                Log.d(
                    LOG_TAG,
                    "Native foreground fallback displaying OneSignal notification: " +
                        (event.notification.title ?: "<no-title>"),
                )
                // Track that an offer notification arrived while Flutter may be detached.
                val additionalData = event.notification.additionalData
                val notificationType = additionalData?.optString("type", "") ?: ""
                val notificationEvent = additionalData?.optString("event", "") ?: ""
                val notificationEventName = additionalData?.optString("eventName", "") ?: ""
                val notificationCategory = additionalData?.optString("category", "") ?: ""
                val notificationPopupType = additionalData?.optString("popupType", "") ?: ""
                if (notificationType == "driver-offer" ||
                    notificationEvent.contains("dispatch.offer_new") ||
                    notificationEventName.contains("dispatch.offer_new") ||
                    (notificationCategory == "dispatch" && notificationPopupType == "delivery_offer")) {
                    lastOfferPushReceivedAt = System.currentTimeMillis()
                    Log.d(LOG_TAG, "Offer push tracked at $lastOfferPushReceivedAt")
                }
                event.notification.display()
            }
        }

    private val lifecycleCallbacks = object : ActivityLifecycleCallbacks {
        override fun onActivityResumed(activity: android.app.Activity) {
            isAppInForeground = true
        }
        override fun onActivityPaused(activity: android.app.Activity) {
            isAppInForeground = false
        }
        override fun onActivityCreated(activity: android.app.Activity, savedInstanceState: Bundle?) {}
        override fun onActivityStarted(activity: android.app.Activity) {}
        override fun onActivityStopped(activity: android.app.Activity) {}
        override fun onActivitySaveInstanceState(activity: android.app.Activity, outState: Bundle) {}
        override fun onActivityDestroyed(activity: android.app.Activity) {}
    }

    override fun onCreate() {
        super.onCreate()
        appContext = applicationContext
        registerActivityLifecycleCallbacks(lifecycleCallbacks)
        createNotificationChannels()
    }

    fun installNativeForegroundFallback(): Boolean {
        return try {
            val notifications = OneSignal.Notifications
            notifications.removeForegroundLifecycleListener(foregroundFallbackListener)
            notifications.addForegroundLifecycleListener(foregroundFallbackListener)
            Log.d(LOG_TAG, "Installed native OneSignal foreground fallback listener")
            true
        } catch (error: Throwable) {
            Log.e(
                LOG_TAG,
                "Failed to install native OneSignal foreground fallback listener",
                error,
            )
            false
        }
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val notificationManager =
            getSystemService(NotificationManager::class.java) ?: return

        val urgentChannel = NotificationChannel(
            HEADS_UP_CHANNEL_ID,
            getString(R.string.driver_heads_up_channel_name),
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = getString(R.string.driver_heads_up_channel_description)
            enableVibration(true)
            setShowBadge(true)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build()
            setSound(Settings.System.DEFAULT_NOTIFICATION_URI, audioAttributes)
        }

        val generalChannel = NotificationChannel(
            GENERAL_CHANNEL_ID,
            getString(R.string.driver_general_channel_name),
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = getString(R.string.driver_general_channel_description)
            enableVibration(true)
            setShowBadge(true)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }

        notificationManager.createNotificationChannel(urgentChannel)
        notificationManager.createNotificationChannel(generalChannel)
    }

    companion object {
        private const val LOG_TAG = "DriverNotifications"
        const val HEADS_UP_CHANNEL_ID = "zadana_heads_up_notifications"
        const val GENERAL_CHANNEL_ID = "zadana_driver_general_notifications"

        /**
         * Timestamp (millis) of the last offer push notification received natively.
         * Flutter reads and clears this on resume to trigger a home refresh.
         */
        @Volatile
        @JvmStatic
        var lastOfferPushReceivedAt: Long = 0L

        /**
         * Whether the app currently has a resumed Activity (is in foreground).
         * Used by [OneSignalNotificationServiceExtension] to skip showing the
         * native overlay when the in-app UI is already handling the offer.
         */
        @Volatile
        @JvmStatic
        var isAppInForeground: Boolean = false

        @Volatile
        @JvmStatic
        var appContext: android.content.Context? = null
    }
}
