package com.example.zadana_delivery

import android.app.Application
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.os.Build
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
                event.notification.display()
            }
        }

    override fun onCreate() {
        super.onCreate()
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
    }
}
