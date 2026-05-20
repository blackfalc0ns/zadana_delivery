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

/**
 * Native system overlay that displays an incoming trip request above all apps.
 * Uses TYPE_APPLICATION_OVERLAY to show even when the app is backgrounded.
 */
class TripRequestSystemOverlay(private val context: Context) {

    companion object {
        private const val TAG = "TripOverlay"
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

    @SuppressLint("ClickableViewAccessibility")
    fun show(data: Map<String, Any?>) {
        if (!canDrawOverlays()) {
            Log.w(TAG, "Cannot draw overlays — permission not granted")
            return
        }

        // Dismiss any existing overlay first
        hide()

        val assignmentId = data["assignment_id"]?.toString() ?: ""
        val vendorName = data["vendor_name"]?.toString() ?: ""
        val pickupAddress = data["pickup_address"]?.toString() ?: ""
        val deliveryAddress = data["delivery_address"]?.toString() ?: ""
        val distanceKm = (data["distance_km"] as? Number)?.toDouble() ?: 0.0
        val eta = data["eta"]?.toString() ?: ""
        val payout = (data["payout"] as? Number)?.toDouble() ?: 0.0
        val totalAmount = (data["total_amount"] as? Number)?.toDouble() ?: 0.0
        val paymentMethod = data["payment_method"]?.toString() ?: ""
        val countdownSeconds = (data["countdown_seconds"] as? Number)?.toInt() ?: 30
        val customerName = data["customer_name"]?.toString() ?: ""

        currentAssignmentId = assignmentId

        val density = context.resources.displayMetrics.density

        // Build the overlay layout
        val rootLayout = buildOverlayLayout(
            density = density,
            vendorName = vendorName,
            pickupAddress = pickupAddress,
            deliveryAddress = deliveryAddress,
            distanceKm = distanceKm,
            eta = eta,
            payout = payout,
            totalAmount = totalAmount,
            paymentMethod = paymentMethod,
            countdownSeconds = countdownSeconds,
            customerName = customerName,
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
            Log.d(TAG, "Overlay shown for assignment: $assignmentId")
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
                onReject?.invoke(currentAssignmentId)
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
                onAccept?.invoke(currentAssignmentId)
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
                onTap?.invoke(currentAssignmentId)
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
