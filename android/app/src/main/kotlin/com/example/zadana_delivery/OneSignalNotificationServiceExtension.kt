package com.example.zadana_delivery

import androidx.annotation.Keep
import androidx.core.app.NotificationCompat
import com.onesignal.notifications.IDisplayableMutableNotification
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension
import org.json.JSONObject

@Keep
class OneSignalNotificationServiceExtension : INotificationServiceExtension {
    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        val notification = event.notification
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
        val payloadType = additionalData.optString("type", "").trim().lowercase()
        val isOfferNotification =
            payloadType == "driver-offer" || eventType.contains("dispatch.offer_new")
        if (!isOfferNotification) {
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
        val payloadType = additionalData?.optString("type")?.trim()?.lowercase().orEmpty()

        if (urgentEvents.any { eventType.contains(it) } ||
            payloadType.contains("offer") ||
            payloadType.contains("suspend")
        ) {
            return MainApplication.HEADS_UP_CHANNEL_ID
        }

        return MainApplication.GENERAL_CHANNEL_ID
    }

    companion object {
        private val urgentEvents = setOf(
            "dispatch.offer_new",
            "account.suspend",
            "assignment.active_order_cancelled",
            "support.request_evidence",
        )
    }
}
