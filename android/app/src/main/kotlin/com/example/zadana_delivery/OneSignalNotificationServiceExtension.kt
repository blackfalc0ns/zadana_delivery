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
            android.util.Log.d("TripOverlay", "Push additionalData is NULL")
            return
        }

        android.util.Log.d("TripOverlay", "═══ PUSH PAYLOAD RECEIVED ═══")
        android.util.Log.d("TripOverlay", "Full additionalData: $additionalData")
        android.util.Log.d("TripOverlay", "Keys: ${additionalData.keys().asSequence().toList()}")

        // Log each important field individually
        val fieldsToCheck = listOf(
            "vendorName", "vendor_name",
            "pickupAddress", "pickup_address",
            "deliveryAddress", "delivery_address",
            "customerName", "customer_name",
            "codAmount", "cod_amount",
            "payout", "deliveryFee",
            "totalAmount", "total_amount",
            "itemsCount", "items_count",
            "paymentMethod", "payment_method",
            "estimatedDistanceKm", "distanceKm",
            "countdownSeconds",
            "assignmentId", "assignment_id",
            "type", "event", "eventName", "category", "popupType",
            "dataObject", "data", "payload"
        )
        for (field in fieldsToCheck) {
            val value = additionalData.opt(field)
            if (value != null) {
                android.util.Log.d("TripOverlay", "  [$field] = $value")
            }
        }
        android.util.Log.d("TripOverlay", "═══════════════════════════════")

        val eventType = additionalData.optString("event", "").trim().lowercase()
        val eventName = additionalData.optString("eventName", "").trim().lowercase()
        val payloadType = additionalData.optString("type", "").trim().lowercase()
        val category = additionalData.optString("category", "").trim().lowercase()
        val popupType = additionalData.optString("popupType", "").trim().lowercase()
        val isOfferNotification =
            payloadType == "driver-offer" ||
            eventType.contains("dispatch.offer_new") ||
            eventName.contains("dispatch.offer_new") ||
            (category == "dispatch" && popupType == "delivery_offer")
        if (!isOfferNotification) {
            android.util.Log.d("TripOverlay", "Not an offer notification. type=$payloadType event=$eventType eventName=$eventName category=$category popupType=$popupType")
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

    companion object {
        private val urgentEvents = setOf(
            "dispatch.offer_new",
            "dispatch.offer_expired",
            "account.suspend",
            "assignment.active_order_cancelled",
            "support.request_evidence",
        )
    }
}
