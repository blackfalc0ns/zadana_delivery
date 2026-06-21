package com.example.zadana_delivery

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val assignmentId = intent.getStringExtra(EXTRA_ASSIGNMENT_ID)
        val orderId = intent.getStringExtra(EXTRA_ORDER_ID)
        val notificationId = intent.getIntExtra(EXTRA_NOTIFICATION_ID, -1)
        val orderTitle = intent.getStringExtra(EXTRA_ORDER_TITLE) ?: "الطلب"

        Log.d(TAG, "Notification action received: action=$action, assignmentId=$assignmentId, orderId=$orderId")

        if (assignmentId.isNullOrEmpty()) {
            Log.w(TAG, "Ignoring notification action: missing assignmentId")
            return
        }

        // Dismiss the notification first
        if (notificationId != -1) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
            notificationManager.cancel(notificationId)
        }

        when (action) {
            ACTION_ACCEPT -> {
                handleAction(context, "accept", assignmentId, orderId, orderTitle)
            }
            ACTION_REJECT -> {
                handleAction(context, "reject", assignmentId, orderId, orderTitle)
            }
        }
    }

    private fun handleAction(context: Context, action: String, assignmentId: String, orderId: String?, orderTitle: String) {
        // Store the action to be consumed by Flutter
        pendingAction = PendingNotificationAction(
            action = action,
            assignmentId = assignmentId,
            orderId = orderId,
            orderTitle = orderTitle
        )
        Log.d(TAG, "Stored pending $action action for assignmentId=$assignmentId")
        
        // Launch the app - Flutter will show the dialog
        launchApp(context)
        
        // Try to notify Flutter immediately if engine is ready
        notifyFlutterIfReady()
    }

    private fun notifyFlutterIfReady() {
        try {
            val action = pendingAction
            if (action != null) {
                val engine = flutterEngine ?: return
                val channel = MethodChannel(
                    engine.dartExecutor.binaryMessenger,
                    NOTIFICATIONS_CHANNEL_NAME
                )
                channel.invokeMethod(
                    "onNotificationAction",
                    mapOf(
                        "action" to action.action,
                        "assignmentId" to action.assignmentId,
                        "orderId" to action.orderId,
                        "orderTitle" to action.orderTitle
                    )
                )
                Log.d(TAG, "Notified Flutter of ${action.action} action")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to notify Flutter immediately: ${e.message}")
        }
    }

    private fun launchApp(context: Context) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        launchIntent?.apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            context.startActivity(this)
        }
    }

    data class PendingNotificationAction(
        val action: String,
        val assignmentId: String,
        val orderId: String?,
        val orderTitle: String
    )

    companion object {
        private const val TAG = "NotificationAction"
        const val ACTION_ACCEPT = "com.example.zadana_delivery.ACCEPT_OFFER"
        const val ACTION_REJECT = "com.example.zadana_delivery.REJECT_OFFER"
        const val EXTRA_ASSIGNMENT_ID = "assignment_id"
        const val EXTRA_ORDER_ID = "order_id"
        const val EXTRA_ORDER_TITLE = "order_title"
        const val EXTRA_NOTIFICATION_ID = "notification_id"
        private const val NOTIFICATIONS_CHANNEL_NAME = "zadana_delivery/native_notifications"

        @Volatile
        @JvmStatic
        var pendingAction: PendingNotificationAction? = null

        @Volatile
        @JvmStatic
        var flutterEngine: FlutterEngine? = null
    }
}
