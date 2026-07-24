package com.zadana.delivery

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class NotificationActionReceiver : BroadcastReceiver() {
    private val scope = CoroutineScope(Dispatchers.Main + Job())

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
                handleAccept(context, assignmentId, orderId, orderTitle)
            }
            ACTION_REJECT -> {
                handleReject(context, assignmentId, orderId, orderTitle)
            }
        }
    }

    private fun handleAccept(context: Context, assignmentId: String, orderId: String?, orderTitle: String) {
        // Show loading toast
        Toast.makeText(context, "جاري قبول $orderTitle...", Toast.LENGTH_SHORT).show()
        
        scope.launch {
            val result = NotificationApiService.acceptOffer(context, assignmentId)
            
            when (result) {
                is NotificationApiService.ApiResult.Success -> {
                    Log.d(TAG, "Accept offer succeeded via native API")
                    Toast.makeText(context, "تم قبول الطلب بنجاح", Toast.LENGTH_SHORT).show()
                    
                    // Store the successful action result
                    pendingAction = PendingNotificationAction(
                        action = "accept",
                        assignmentId = assignmentId,
                        orderId = orderId,
                        orderTitle = orderTitle,
                        wasExecuted = true,
                        wasSuccessful = true
                    )
                    
                    // Launch the app to show the order details
                    launchApp(context)
                    notifyFlutterIfReady()
                }
                is NotificationApiService.ApiResult.Error -> {
                    Log.e(TAG, "Accept offer failed via native API: ${result.message}")
                    Toast.makeText(context, "فشل قبول الطلب: ${result.message}", Toast.LENGTH_LONG).show()
                    
                    // Store the failed action
                    pendingAction = PendingNotificationAction(
                        action = "accept",
                        assignmentId = assignmentId,
                        orderId = orderId,
                        orderTitle = orderTitle,
                        wasExecuted = true,
                        wasSuccessful = false,
                        errorMessage = result.message
                    )
                }
            }
        }
    }

    private fun handleReject(context: Context, assignmentId: String, orderId: String?, orderTitle: String) {
        // Show loading toast
        Toast.makeText(context, "جاري رفض $orderTitle...", Toast.LENGTH_SHORT).show()
        
        scope.launch {
            val result = NotificationApiService.rejectOffer(context, assignmentId)
            
            when (result) {
                is NotificationApiService.ApiResult.Success -> {
                    Log.d(TAG, "Reject offer succeeded via native API")
                    Toast.makeText(context, "تم رفض الطلب", Toast.LENGTH_SHORT).show()
                    
                    // Store the successful action result
                    pendingAction = PendingNotificationAction(
                        action = "reject",
                        assignmentId = assignmentId,
                        orderId = orderId,
                        orderTitle = orderTitle,
                        wasExecuted = true,
                        wasSuccessful = true
                    )
                    
                    // Optionally launch the app
                    launchApp(context)
                    notifyFlutterIfReady()
                }
                is NotificationApiService.ApiResult.Error -> {
                    Log.e(TAG, "Reject offer failed via native API: ${result.message}")
                    Toast.makeText(context, "فشل رفض الطلب: ${result.message}", Toast.LENGTH_LONG).show()
                    
                    // Store the failed action
                    pendingAction = PendingNotificationAction(
                        action = "reject",
                        assignmentId = assignmentId,
                        orderId = orderId,
                        orderTitle = orderTitle,
                        wasExecuted = true,
                        wasSuccessful = false,
                        errorMessage = result.message
                    )
                }
            }
        }
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
                        "orderTitle" to action.orderTitle,
                        "wasExecuted" to action.wasExecuted,
                        "wasSuccessful" to action.wasSuccessful,
                        "errorMessage" to action.errorMessage
                    )
                )
                Log.d(TAG, "Notified Flutter of ${action.action} action (executed=${action.wasExecuted}, success=${action.wasSuccessful})")
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
        val orderTitle: String,
        val wasExecuted: Boolean = false,
        val wasSuccessful: Boolean = false,
        val errorMessage: String? = null
    )

    companion object {
        private const val TAG = "NotificationAction"
        const val ACTION_ACCEPT = "com.zadana.delivery.ACCEPT_OFFER"
        const val ACTION_REJECT = "com.zadana.delivery.REJECT_OFFER"
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
