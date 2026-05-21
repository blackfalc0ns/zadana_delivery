package com.example.zadana_delivery

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.CountDownTimer
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import org.json.JSONObject

/**
 * Native system overlay that displays an incoming trip request above all apps.
 * Uses TYPE_APPLICATION_OVERLAY to show even when the app is backgrounded.
 */
private data class OverlayData(
    val assignmentId: String,
    val vendorName: String,
    val pickupAddress: String,
    val deliveryAddress: String,
    val distanceKm: Double,
    val eta: String,
    val payout: Double,
    val totalAmount: Double,
    val paymentMethod: String,
    val countdownSeconds: Int,
    val customerName: String,
)

class TripRequestSystemOverlay(private val context: Context) {

    companion object {
        private const val TAG = "TripOverlay"

        fun showOfferOverlayFromPush(context: Context, payload: JSONObject?) {
            if (payload == null) {
                Log.d(TAG, "Native push overlay skipped: payload is null")
                return
            }

            val data = buildOverlayMapFromPushPayload(payload)
            val assignmentId = data["assignment_id"]?.toString()?.trim().orEmpty()
            if (assignmentId.isEmpty()) {
                Log.d(TAG, "Native push overlay skipped: missing assignment id")
                return
            }

            Handler(Looper.getMainLooper()).post {
                val overlay = TripRequestSystemOverlay(context.applicationContext)
                val nativeActionClient =
                    NativeTripOfferActionClient(context.applicationContext)
                overlay.setCallbacks(
                    onAccept = { currentAssignmentId ->
                        Log.d(TAG, "Native push overlay accept tapped: $currentAssignmentId")
                        nativeActionClient.acceptOffer(currentAssignmentId)
                    },
                    onReject = { currentAssignmentId ->
                        Log.d(TAG, "Native push overlay reject tapped: $currentAssignmentId")
                        nativeActionClient.rejectOffer(currentAssignmentId)
                    },
                    onTap = { currentAssignmentId ->
                        Log.d(TAG, "Native push overlay body tapped: $currentAssignmentId")
                        overlay.bringAppToForeground()
                    },
                )
                overlay.show(data)
            }
        }

        private fun buildOverlayMapFromPushPayload(payload: JSONObject): Map<String, Any?> {
            val dataObject = payload.optJSONObject("dataObject")
                ?: payload.optJSONObject("data")
                ?: payload.optJSONObject("payload")

            fun firstString(vararg values: String?): String {
                for (value in values) {
                    val normalized = value?.trim().orEmpty()
                    if (normalized.isNotEmpty()) {
                        return normalized
                    }
                }
                return ""
            }

            fun firstDouble(vararg values: Any?): Double {
                for (value in values) {
                    when (value) {
                        is Number -> return value.toDouble()
                        is String -> value.toDoubleOrNull()?.let { return it }
                    }
                }
                return 0.0
            }

            fun firstInt(vararg values: Any?): Int {
                for (value in values) {
                    when (value) {
                        is Number -> return value.toInt()
                        is String -> value.toIntOrNull()?.let { return it }
                    }
                }
                return 30
            }

            fun jsonString(source: JSONObject?, key: String): String? {
                if (source == null || !source.has(key)) return null
                return source.optString(key, null)
            }

            fun jsonValue(source: JSONObject?, key: String): Any? {
                if (source == null || !source.has(key)) return null
                return source.opt(key)
            }

            return mapOf(
                "assignment_id" to firstString(
                    jsonString(payload, "assignmentId"),
                    jsonString(payload, "assignment_id"),
                    jsonString(dataObject, "assignmentId"),
                    jsonString(dataObject, "assignment_id"),
                    jsonString(payload, "referenceId"),
                ),
                "order_id" to firstString(
                    jsonString(payload, "orderId"),
                    jsonString(payload, "order_id"),
                    jsonString(dataObject, "orderId"),
                    jsonString(dataObject, "order_id"),
                ),
                "order_number" to firstString(
                    jsonString(payload, "orderNumber"),
                    jsonString(payload, "order_number"),
                    jsonString(dataObject, "orderNumber"),
                    jsonString(dataObject, "order_number"),
                ),
                "vendor_name" to firstString(
                    jsonString(payload, "vendorName"),
                    jsonString(payload, "vendor_name"),
                    jsonString(dataObject, "vendorName"),
                    jsonString(dataObject, "vendor_name"),
                ),
                "pickup_address" to firstString(
                    jsonString(payload, "pickupAddress"),
                    jsonString(payload, "pickup_address"),
                    jsonString(payload, "vendorAddress"),
                    jsonString(dataObject, "pickupAddress"),
                    jsonString(dataObject, "pickup_address"),
                    jsonString(dataObject, "vendorAddress"),
                ),
                "delivery_address" to firstString(
                    jsonString(payload, "deliveryAddress"),
                    jsonString(payload, "delivery_address"),
                    jsonString(payload, "customerAddress"),
                    jsonString(dataObject, "deliveryAddress"),
                    jsonString(dataObject, "delivery_address"),
                    jsonString(dataObject, "customerAddress"),
                ),
                "distance_km" to firstDouble(
                    jsonValue(payload, "estimatedDistanceKm"),
                    jsonValue(payload, "distanceKm"),
                    jsonValue(dataObject, "estimatedDistanceKm"),
                    jsonValue(dataObject, "distanceKm"),
                ),
                "eta" to firstString(
                    jsonString(payload, "estimatedEta"),
                    jsonString(payload, "eta"),
                    jsonString(dataObject, "estimatedEta"),
                    jsonString(dataObject, "eta"),
                ),
                "payout" to firstDouble(
                    jsonValue(payload, "payout"),
                    jsonValue(payload, "deliveryFee"),
                    jsonValue(dataObject, "payout"),
                    jsonValue(dataObject, "deliveryFee"),
                ),
                "total_amount" to firstDouble(
                    jsonValue(payload, "totalAmount"),
                    jsonValue(dataObject, "totalAmount"),
                ),
                "payment_method" to firstString(
                    jsonString(payload, "paymentMethod"),
                    jsonString(dataObject, "paymentMethod"),
                ),
                "countdown_seconds" to firstInt(
                    jsonValue(payload, "countdownSeconds"),
                    jsonValue(dataObject, "countdownSeconds"),
                ),
                "customer_name" to firstString(
                    jsonString(payload, "customerName"),
                    jsonString(payload, "customer_name"),
                    jsonString(dataObject, "customerName"),
                    jsonString(dataObject, "customer_name"),
                ),
            )
        }
    }

    private val windowManager: WindowManager =
        context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

    private var overlayView: View? = null
    private var countDownTimer: CountDownTimer? = null
    private var onAccept: ((String) -> Unit)? = null
    private var onReject: ((String) -> Unit)? = null
    private var onTap: ((String) -> Unit)? = null
    private var currentAssignmentId: String = ""

    fun canDrawOverlays(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(context)
        } else {
            true
        }
    }

    fun openOverlaySettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                android.net.Uri.parse("package:${context.packageName}")
            ).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
        }
    }

    private fun parseOverlayData(data: Map<String, Any?>): OverlayData {
        return OverlayData(
            assignmentId = data["assignment_id"]?.toString() ?: "",
            vendorName = data["vendor_name"]?.toString() ?: "",
            pickupAddress = data["pickup_address"]?.toString() ?: "",
            deliveryAddress = data["delivery_address"]?.toString() ?: "",
            distanceKm = (data["distance_km"] as? Number)?.toDouble() ?: 0.0,
            eta = data["eta"]?.toString() ?: "",
            payout = (data["payout"] as? Number)?.toDouble() ?: 0.0,
            totalAmount = (data["total_amount"] as? Number)?.toDouble() ?: 0.0,
            paymentMethod = data["payment_method"]?.toString() ?: "",
            countdownSeconds = (data["countdown_seconds"] as? Number)?.toInt() ?: 30,
            customerName = data["customer_name"]?.toString() ?: "",
        )
    }

    @SuppressLint("ClickableViewAccessibility")
    fun show(data: Map<String, Any?>) {
        if (!canDrawOverlays()) {
            Log.w(TAG, "Cannot draw overlays — permission not granted")
            return
        }

        // Dismiss any existing overlay first
        hide()

        val overlayData = parseOverlayData(data)
        currentAssignmentId = overlayData.assignmentId

        val density = context.resources.displayMetrics.density

        // Build the overlay layout
        val rootLayout = buildOverlayLayout(
            density = density,
            vendorName = overlayData.vendorName,
            pickupAddress = overlayData.pickupAddress,
            deliveryAddress = overlayData.deliveryAddress,
            distanceKm = overlayData.distanceKm,
            eta = overlayData.eta,
            payout = overlayData.payout,
            totalAmount = overlayData.totalAmount,
            paymentMethod = overlayData.paymentMethod,
            countdownSeconds = overlayData.countdownSeconds,
            customerName = overlayData.customerName,
        )

        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL
            x = 0
            y = 0
        }

        try {
            windowManager.addView(rootLayout, layoutParams)
            overlayView = rootLayout
            Log.d(TAG, "Overlay shown for assignment: ${overlayData.assignmentId}")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to show overlay", e)
        }
    }

    fun hide() {
        countDownTimer?.cancel()
        countDownTimer = null
        val view = overlayView
        if (view != null) {
            try {
                windowManager.removeView(view)
            } catch (e: Exception) {
                Log.w(TAG, "Failed to remove overlay view", e)
            }
            overlayView = null
        }
    }

    fun bringAppToForeground() {
        val launchIntent =
            context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP,
                )
            }
        if (launchIntent == null) {
            Log.w(TAG, "Unable to bring app to foreground: launch intent missing")
            return
        }
        context.startActivity(launchIntent)
    }

    fun setCallbacks(
        onAccept: (String) -> Unit,
        onReject: (String) -> Unit,
        onTap: (String) -> Unit,
    ) {
        this.onAccept = onAccept
        this.onReject = onReject
        this.onTap = onTap
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun buildOverlayLayout(
        density: Float,
        vendorName: String,
        pickupAddress: String,
        deliveryAddress: String,
        distanceKm: Double,
        eta: String,
        payout: Double,
        totalAmount: Double,
        paymentMethod: String,
        countdownSeconds: Int,
        customerName: String,
    ): View {
        val dp = { value: Int -> (value * density).toInt() }

        // Root container
        val root = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(16), dp(16), dp(16), dp(24))
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadii = floatArrayOf(
                    dp(24).toFloat(), dp(24).toFloat(),
                    dp(24).toFloat(), dp(24).toFloat(),
                    0f, 0f, 0f, 0f
                )
            }
            elevation = dp(8).toFloat()
        }

        // Handle bar
        val handleBar = View(context).apply {
            val handleBg = GradientDrawable().apply {
                setColor(Color.parseColor("#DDDDDD"))
                cornerRadius = dp(3).toFloat()
            }
            background = handleBg
        }
        val handleParams = LinearLayout.LayoutParams(dp(40), dp(5)).apply {
            gravity = Gravity.CENTER_HORIZONTAL
            bottomMargin = dp(12)
        }
        root.addView(handleBar, handleParams)

        // Title row: "طلب توصيل جديد" + countdown
        val titleRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val titleText = TextView(context).apply {
            text = "🚗 طلب توصيل جديد"
            setTextColor(Color.parseColor("#1A1A2E"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
            typeface = Typeface.DEFAULT_BOLD
        }
        titleRow.addView(
            titleText,
            LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
        )

        val countdownText = TextView(context).apply {
            text = "${countdownSeconds}s"
            setTextColor(Color.parseColor("#E94560"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            typeface = Typeface.DEFAULT_BOLD
        }
        titleRow.addView(countdownText, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ))

        root.addView(titleRow, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).apply { bottomMargin = dp(8) })

        // Progress bar for countdown
        val progressBar = ProgressBar(
            context, null, android.R.attr.progressBarStyleHorizontal
        ).apply {
            max = countdownSeconds * 1000
            progress = countdownSeconds * 1000
            progressDrawable = context.resources.getDrawable(
                android.R.drawable.progress_horizontal, null
            ).mutate().apply {
                setTint(Color.parseColor("#E94560"))
            }
        }
        root.addView(progressBar, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, dp(4)
        ).apply { bottomMargin = dp(12) })

        // Vendor name
        if (vendorName.isNotEmpty()) {
            val vendorText = TextView(context).apply {
                text = "📍 $vendorName"
                setTextColor(Color.parseColor("#333333"))
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
                typeface = Typeface.DEFAULT_BOLD
            }
            root.addView(vendorText, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(4) })
        }

        // Pickup address
        if (pickupAddress.isNotEmpty()) {
            val pickupText = TextView(context).apply {
                text = "🟢 $pickupAddress"
                setTextColor(Color.parseColor("#555555"))
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
                maxLines = 2
            }
            root.addView(pickupText, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(4) })
        }

        // Delivery address
        if (deliveryAddress.isNotEmpty()) {
            val deliveryText = TextView(context).apply {
                text = "🔴 $deliveryAddress"
                setTextColor(Color.parseColor("#555555"))
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
                maxLines = 2
            }
            root.addView(deliveryText, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(8) })
        }

        // Info row: distance + ETA + payout
        val infoRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        if (distanceKm > 0) {
            val distText = buildInfoChip("📏 ${"%.1f".format(distanceKm)} كم", density)
            infoRow.addView(distText)
        }

        if (eta.isNotEmpty()) {
            val etaText = buildInfoChip("⏱ $eta", density)
            infoRow.addView(etaText)
        }

        if (payout > 0) {
            val payoutText = buildInfoChip("💰 ${"%.1f".format(payout)} ر.س", density)
            infoRow.addView(payoutText)
        }

        root.addView(infoRow, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).apply { bottomMargin = dp(16) })

        // Buttons row: Reject + Accept
        val buttonsRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }

        // Reject button
        val rejectBtn = TextView(context).apply {
            text = "✕ رفض"
            setTextColor(Color.WHITE)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            setPadding(dp(24), dp(14), dp(24), dp(14))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#E94560"))
                cornerRadius = dp(12).toFloat()
            }
            setOnClickListener {
                if (onReject != null) {
                    onReject?.invoke(currentAssignmentId)
                } else {
                    bringAppToForeground()
                }
                hide()
            }
        }
        buttonsRow.addView(rejectBtn, LinearLayout.LayoutParams(
            0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f
        ).apply { marginEnd = dp(8) })

        // Accept button
        val acceptBtn = TextView(context).apply {
            text = "✓ قبول"
            setTextColor(Color.WHITE)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            setPadding(dp(24), dp(14), dp(24), dp(14))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#0F3460"))
                cornerRadius = dp(12).toFloat()
            }
            setOnClickListener {
                if (onAccept != null) {
                    onAccept?.invoke(currentAssignmentId)
                } else {
                    bringAppToForeground()
                }
                hide()
            }
        }
        buttonsRow.addView(acceptBtn, LinearLayout.LayoutParams(
            0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f
        ).apply { marginStart = dp(8) })

        root.addView(buttonsRow, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ))

        // Tap on the overlay body (not buttons) opens the app
        root.setOnTouchListener { _, event ->
            if (event.action == MotionEvent.ACTION_UP) {
                if (onTap != null) {
                    onTap?.invoke(currentAssignmentId)
                } else {
                    bringAppToForeground()
                }
                hide()
            }
            false
        }

        // Start countdown timer
        countDownTimer = object : CountDownTimer(
            (countdownSeconds * 1000).toLong(), 50
        ) {
            override fun onTick(millisUntilFinished: Long) {
                val secondsLeft = (millisUntilFinished / 1000).toInt() + 1
                countdownText.text = "${secondsLeft}s"
                progressBar.progress = millisUntilFinished.toInt()
            }

            override fun onFinish() {
                countdownText.text = "0s"
                progressBar.progress = 0
                // Auto-dismiss after countdown
                Handler(Looper.getMainLooper()).postDelayed({
                    hide()
                }, 500)
            }
        }.start()

        return root
    }

    private fun buildInfoChip(text: String, density: Float): TextView {
        val dp = { value: Int -> (value * density).toInt() }
        return TextView(context).apply {
            this.text = text
            setTextColor(Color.parseColor("#333333"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
            setPadding(dp(10), dp(6), dp(10), dp(6))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#F0F0F0"))
                cornerRadius = dp(8).toFloat()
            }
            val params = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { marginEnd = dp(8) }
            layoutParams = params
        }
    }
}
