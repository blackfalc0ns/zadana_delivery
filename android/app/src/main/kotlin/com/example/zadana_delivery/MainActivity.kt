package com.example.zadana_delivery

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var notificationsChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        cachePendingNotificationIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        cachePendingNotificationIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "consumePendingPayload" -> {
                    result.success(pendingPayload)
                    pendingPayload = null
                }

                else -> result.notImplemented()
            }
        }

        notificationsChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NOTIFICATIONS_CHANNEL_NAME,
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "installNativeForegroundFallback" -> {
                        val installed =
                            (application as? MainApplication)?.installNativeForegroundFallback() ?: false
                        result.success(installed)
                    }

                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun cachePendingNotificationIntent(intent: Intent?) {
        val extras = intent?.extras ?: return
        if (extras.isEmpty) {
            return
        }

        val payload = bundleToMap(extras)
        if (payload.isEmpty()) {
            return
        }

        pendingPayload = HashMap(payload)
    }

    private fun bundleToMap(bundle: Bundle): Map<String, Any?> {
        val map = HashMap<String, Any?>()
        for (key in bundle.keySet()) {
            map[key] = normalizeValue(bundle.get(key))
        }
        return map
    }

    private fun normalizeValue(value: Any?): Any? {
        return when (value) {
            null -> null
            is Bundle -> bundleToMap(value)
            is ArrayList<*> -> value.map { normalizeValue(it) }
            is Array<*> -> value.map { normalizeValue(it) }
            is CharSequence -> value.toString()
            is String,
            is Boolean,
            is Int,
            is Long,
            is Double,
            is Float -> value
            else -> value.toString()
        }
    }

    companion object {
        private const val CHANNEL_NAME = "zadana_delivery/notification_launch"
        private const val NOTIFICATIONS_CHANNEL_NAME =
            "zadana_delivery/native_notifications"

        @Volatile
        private var pendingPayload: HashMap<String, Any?>? = null
    }
}
