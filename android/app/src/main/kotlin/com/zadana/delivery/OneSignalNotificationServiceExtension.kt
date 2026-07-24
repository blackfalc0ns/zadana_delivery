package com.zadana.delivery

import androidx.annotation.Keep
import androidx.core.app.NotificationCompat
import com.onesignal.notifications.IDisplayableMutableNotification
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension
import org.json.JSONObject

@Keep
class OneSignalNotificationServiceExtension : INotificationServiceExtension {
    companion object {
        // Cache to prevent processing the same notification multiple times
        private var lastProcessedNotificationId: String? = null
        private var lastProcessedTime: Long = 0
        private const val DEDUPLICATION_WINDOW_MS = 3000L // 3 seconds
        
        private val urgentEvents = setOf(
            "dispatch.offer_new",
            "dispatch.offer_expired",
            "account.suspend",
            "assignment.active_order_cancelled",
            "support.request_evidence",
        )
    }
    
    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        val notification = event.notification
        
        // Prevent duplicate processing of the same notification
        val notificationId = notification.notificationId
        val currentTime = System.currentTimeMillis()
        if (notificationId == lastProcessedNotificationId && 
            (currentTime - lastProcessedTime) < DEDUPLICATION_WINDOW_MS) {
            android.util.Log.d(
                "OneSignalExtension", 
                "Skipping duplicate notification: $notificationId (processed ${(currentTime - lastProcessedTime) / 1000}s ago)"
            )
            return
        }
        
        // Update cache
        lastProcessedNotificationId = notificationId
        lastProcessedTime = currentTime
        
        val channelId = resolveChannelId(notification)
        maybeShowNativeOfferOverlay(notification.additionalData)
        
        notification.setExtender { builder: NotificationCompat.Builder ->
            builder
                .setSmallIcon(R.drawable.ic_notification_small)
                .setChannelId(channelId)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setDefaults(NotificationCompat.DEFAULT_ALL)
        }
    }

    private fun maybeShowNativeOfferOverlay(additionalData: JSONObject?) {
        if (additionalData == null) {
            return
        }

        val eventType = additionalData.optString("event", "").trim().lowercase()
        val eventName = additionalData.optString("eventName", "").trim().lowercase()
        val payloadType = additionalData.optString("type", "").trim().lowercase()
        val category = additionalData.optString("category", "").trim().lowercase()
        val popupType = additionalData.optString("popupType", "").trim().lowercase()
        
        val isOfferNotification = payloadType == "driver-offer" ||
            eventType.contains("dispatch.offer_new") ||
            eventName.contains("dispatch.offer_new") ||
            (category == "dispatch" && popupType == "delivery_offer")

        if (!isOfferNotification) {
            return
        }

        // Skip native overlay when app is in foreground — the in-app UI handles it.
        if (MainApplication.isAppInForeground) {
            return
        }

        val appContext = MainApplication.appContext
        if (appContext == null) {
            return
        }

        TripRequestSystemOverlay.showOfferOverlayFromPush(appContext, additionalData)
    }

    private fun resolveChannelId(notification: IDisplayableMutableNotification): String {
        val additionalData = notification.additionalData
        val payloadChannelId = additionalData?.optString("android_channel_id")?.trim()
        if (!payloadChannelId.isNullOrEmpty()) {
            return payloadChannelId
        }

        val existingPayloadChannelId =
            additionalData?.optString("existing_android_channel_id")?.trim()
        if (!existingPayloadChannelId.isNullOrEmpty()) {
            return existingPayloadChannelId
        }

        val rawPayloadChannelId = runCatching {
            JSONObject(notification.rawPayload).optString("android_channel_id").trim()
        }.getOrNull()
        if (!rawPayloadChannelId.isNullOrEmpty()) {
            return rawPayloadChannelId
        }

        val rawExistingChannelId = runCatching {
            JSONObject(notification.rawPayload).optString("existing_android_channel_id").trim()
        }.getOrNull()
        if (!rawExistingChannelId.isNullOrEmpty()) {
            return rawExistingChannelId
        }

        val eventType = additionalData?.optString("event")?.trim()?.lowercase().orEmpty()
        val eventName = additionalData?.optString("eventName")?.trim()?.lowercase().orEmpty()
        val payloadType = additionalData?.optString("type")?.trim()?.lowercase().orEmpty()
        val category = additionalData?.optString("category")?.trim()?.lowercase().orEmpty()

        if (urgentEvents.any { eventType.contains(it) } ||
            urgentEvents.any { eventName.contains(it) } ||
            payloadType.contains("offer") ||
            payloadType.contains("suspend") ||
            (category == "dispatch")
        ) {
            return MainApplication.HEADS_UP_CHANNEL_ID
        }

        return MainApplication.GENERAL_CHANNEL_ID
    }
}
