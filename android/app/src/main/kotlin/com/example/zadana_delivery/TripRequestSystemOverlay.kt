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
    val orderNumber: String,
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
    val itemsCount: Int,
    val codAmount: Double,
    val distanceText: String,
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
                "items_count" to firstInt(
                    jsonValue(payload, "itemsCount"),
                    jsonValue(payload, "items_count"),
                    jsonValue(dataObject, "itemsCount"),
                    jsonValue(dataObject, "items_count"),
                ),
                "cod_amount" to firstDouble(
                    jsonValue(payload, "codAmount"),
                    jsonValue(payload, "cod_amount"),
                    jsonValue(dataObject, "codAmount"),
                    jsonValue(dataObject, "cod_amount"),
                ),
                "distance_text" to firstString(
                    jsonString(payload, "distanceText"),
                    jsonString(payload, "distance_text"),
                    jsonString(payload, "distance"),
                    jsonString(dataObject, "distanceText"),
                    jsonString(dataObject, "distance_text"),
                    jsonString(dataObject, "distance"),
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
            orderNumber = data["order_number"]?.toString() ?: "",
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
            itemsCount = (data["items_count"] as? Number)?.toInt() ?: 0,
            codAmount = (data["cod_amount"] as? Number)?.toDouble() ?: 0.0,
            distanceText = data["distance_text"]?.toString() ?: "",
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
            orderNumber = overlayData.orderNumber,
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
            itemsCount = overlayData.itemsCount,
            codAmount = overlayData.codAmount,
            distanceText = overlayData.distanceText,
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
        orderNumber: String,
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
        itemsCount: Int,
        codAmount: Double,
        distanceText: String,
    ): View {
        val dp = { value: Int -> (value * density).toInt() }

        // App colors
        val colorPrimary = Color.parseColor("#007A92")
        val colorSecondary = Color.parseColor("#E48215")
        val colorError = Color.parseColor("#E53935")
        val colorSuccess = Color.parseColor("#4CAF50")
        val colorTextPrimary = Color.parseColor("#212121")
        val colorTextSecondary = Color.parseColor("#757575")
        val colorSurface = Color.WHITE
        val colorDivider = Color.parseColor("#E0E0E0")

        // Root container
        val root = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(20), dp(14), dp(20), dp(24))
            background = GradientDrawable().apply {
                setColor(colorSurface)
                cornerRadii = floatArrayOf(
                    dp(24).toFloat(), dp(24).toFloat(),
                    dp(24).toFloat(), dp(24).toFloat(),
                    0f, 0f, 0f, 0f
                )
            }
            elevation = dp(16).toFloat()
        }

        // Handle bar
        val handleBar = View(context).apply {
            background = GradientDrawable().apply {
                setColor(colorDivider)
                cornerRadius = dp(3).toFloat()
            }
        }
        val handleParams = LinearLayout.LayoutParams(dp(40), dp(5)).apply {
            gravity = Gravity.CENTER_HORIZONTAL
            bottomMargin = dp(12)
        }
        root.addView(handleBar, handleParams)

        // ── Countdown timer text (hidden, used by timer) ──
        val countdownText = TextView(context).apply {
            text = "${countdownSeconds}s"
            setTextColor(colorSecondary)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
            typeface = Typeface.DEFAULT_BOLD
            setPadding(dp(10), dp(5), dp(10), dp(5))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFF3E0"))
                cornerRadius = dp(10).toFloat()
                setStroke(1, Color.parseColor("#FFE0B2"))
            }
            gravity = Gravity.CENTER
        }
        root.addView(countdownText, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).apply {
            gravity = Gravity.CENTER_HORIZONTAL
            bottomMargin = dp(10)
        })

        // Progress bar for countdown
        val progressBar = ProgressBar(
            context, null, android.R.attr.progressBarStyleHorizontal
        ).apply {
            max = countdownSeconds * 1000
            progress = countdownSeconds * 1000
            progressDrawable = context.resources.getDrawable(
                android.R.drawable.progress_horizontal, null
            ).mutate().apply {
                setTint(colorPrimary)
            }
        }
        root.addView(progressBar, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, dp(3)
        ).apply { bottomMargin = dp(14) })

        // ── Payout (driver earnings) — prominent section ──
        val payoutContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(dp(14), dp(12), dp(14), dp(12))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#E8F5E9"))
                cornerRadius = dp(12).toFloat()
                setStroke(1, Color.parseColor("#C8E6C9"))
            }
        }

        val payoutLabel = TextView(context).apply {
            text = "أجرة التوصيل"
            setTextColor(colorTextPrimary)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
            typeface = Typeface.DEFAULT_BOLD
        }
        payoutContainer.addView(payoutLabel, LinearLayout.LayoutParams(
            0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f
        ))

        val payoutValue = TextView(context).apply {
            text = "${"%.1f".format(payout)} ر.س"
            setTextColor(colorSuccess)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 20f)
            typeface = Typeface.DEFAULT_BOLD
        }
        payoutContainer.addView(payoutValue, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ))

        root.addView(payoutContainer, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).apply { bottomMargin = dp(12) })

        // ── COD Amount (collection from customer) ──
        val requiresCollection = codAmount > 0
        if (requiresCollection) {
            val codContainer = LinearLayout(context).apply {
                orientation = LinearLayout.HORIZONTAL
                gravity = Gravity.CENTER_VERTICAL
                setPadding(dp(14), dp(10), dp(14), dp(10))
                background = GradientDrawable().apply {
                    setColor(Color.parseColor("#FFF3E0"))
                    cornerRadius = dp(12).toFloat()
                    setStroke(1, Color.parseColor("#FFE0B2"))
                }
            }

            val codLabel = TextView(context).apply {
                text = "تحصيل من العميل"
                setTextColor(colorTextPrimary)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
                typeface = Typeface.DEFAULT_BOLD
            }
            codContainer.addView(codLabel, LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f
            ))

            val codValue = TextView(context).apply {
                text = "${"%.1f".format(codAmount)} ر.س"
                setTextColor(colorSecondary)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
                typeface = Typeface.DEFAULT_BOLD
            }
            codContainer.addView(codValue, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ))

            root.addView(codContainer, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(12) })
        } else {
            // Show payment status (paid online)
            val normalizedMethod = paymentMethod.trim().lowercase()
            val isPaidOnline = normalizedMethod.isNotEmpty() &&
                (normalizedMethod.contains("online") ||
                 normalizedMethod.contains("card") ||
                 normalizedMethod.contains("visa") ||
                 normalizedMethod.contains("mada") ||
                 normalizedMethod.contains("apple") ||
                 normalizedMethod.contains("stc"))
            if (isPaidOnline) {
                val paidText = TextView(context).apply {
                    text = "مدفوع أونلاين ✓"
                    setTextColor(colorSuccess)
                    setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
                    typeface = Typeface.DEFAULT_BOLD
                    setPadding(dp(14), dp(6), dp(14), dp(6))
                }
                root.addView(paidText, LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply { bottomMargin = dp(8) })
            }
        }

        // ── Distance ──
        val distanceDisplay = distanceText.ifEmpty {
            if (distanceKm > 0) "${"%.1f".format(distanceKm)} كم" else ""
        }
        if (distanceDisplay.isNotEmpty()) {
            val distanceTextView = TextView(context).apply {
                text = "المسافة: $distanceDisplay"
                setTextColor(colorTextSecondary)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
                typeface = Typeface.DEFAULT_BOLD
            }
            root.addView(distanceTextView, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(8) })
        }

        // ── Pickup location ──
        val pickupDisplay = if (pickupAddress.isNotEmpty()) pickupAddress else vendorName
        if (pickupDisplay.isNotEmpty()) {
            val pickupText = TextView(context).apply {
                text = "الاستلام: $pickupDisplay"
                setTextColor(colorTextPrimary)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
                typeface = Typeface.DEFAULT_BOLD
                maxLines = 2
            }
            root.addView(pickupText, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(6) })
        }

        // ── Delivery location ──
        val deliveryDisplay = if (deliveryAddress.isNotEmpty()) deliveryAddress else customerName
        if (deliveryDisplay.isNotEmpty()) {
            val deliveryText = TextView(context).apply {
                text = "التوصيل: $deliveryDisplay"
                setTextColor(colorTextPrimary)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
                typeface = Typeface.DEFAULT_BOLD
                maxLines = 2
            }
            root.addView(deliveryText, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(6) })
        }

        // ── Items count ──
        if (itemsCount > 0) {
            val itemsText = TextView(context).apply {
                text = "عدد الأصناف: $itemsCount"
                setTextColor(colorTextSecondary)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f)
                typeface = Typeface.DEFAULT_BOLD
            }
            root.addView(itemsText, LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { bottomMargin = dp(14) })
        }

        // ── Buttons row: Accept + Reject ──
        val buttonsRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }

        // Accept button
        val acceptBtn = TextView(context).apply {
            text = "قبول"
            setTextColor(Color.WHITE)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            setPadding(dp(20), dp(14), dp(20), dp(14))
            background = GradientDrawable().apply {
                setColor(colorPrimary)
                cornerRadius = dp(14).toFloat()
            }
            setOnClickListener {
                if (onAccept != null) {
                    onAccept?.invoke(currentAssignmentId)
                }
                bringAppToForeground()
                hide()
            }
        }
        buttonsRow.addView(acceptBtn, LinearLayout.LayoutParams(
            0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f
        ).apply { marginEnd = dp(8) })

        // Reject button
        val rejectBtn = TextView(context).apply {
            text = "رفض"
            setTextColor(colorError)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            typeface = Typeface.DEFAULT_BOLD
            gravity = Gravity.CENTER
            setPadding(dp(20), dp(14), dp(20), dp(14))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFEBEE"))
                setStroke(dp(1), colorError)
                cornerRadius = dp(14).toFloat()
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


}
