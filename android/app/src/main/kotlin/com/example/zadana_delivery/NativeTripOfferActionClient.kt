package com.example.zadana_delivery

import android.content.Context
import android.util.Log
import org.json.JSONObject
import java.io.BufferedWriter
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors

class NativeTripOfferActionClient(private val context: Context) {
    companion object {
        private const val TAG = "NativeTripOfferAction"
        private const val BASE_API_URL = "https://zadana.runasp.net/api"
        private const val PREFS_NAME = "FlutterSharedPreferences"
        private const val ACCESS_TOKEN_KEY = "flutter.accessToken"
        private const val REFRESH_TOKEN_KEY = "flutter.refreshToken"
        private const val IS_ACCESS_TOKEN_SAVED_KEY = "flutter.isAccessTokenSaved"
        private val executor = Executors.newSingleThreadExecutor()
    }

    fun acceptOffer(
        assignmentId: String,
        onComplete: ((Boolean) -> Unit)? = null,
    ) {
        performRequest(
            path = "/drivers/offers/$assignmentId/accept",
            requestBody = null,
            onComplete = onComplete,
        )
    }

    fun rejectOffer(
        assignmentId: String,
        reason: String? = null,
        onComplete: ((Boolean) -> Unit)? = null,
    ) {
        val body = if (reason.isNullOrBlank()) {
            JSONObject()
        } else {
            JSONObject(mapOf("reason" to reason))
        }
        performRequest(
            path = "/drivers/offers/$assignmentId/reject",
            requestBody = body,
            onComplete = onComplete,
        )
    }

    private fun performRequest(
        path: String,
        requestBody: JSONObject?,
        onComplete: ((Boolean) -> Unit)? = null,
    ) {
        executor.execute {
            val token = readAccessToken()
            if (token.isBlank()) {
                Log.w(TAG, "Request skipped because native access token is missing")
                onComplete?.invoke(false)
                return@execute
            }

            val url = URL(BASE_API_URL + path)
            val connection = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "POST"
                connectTimeout = 15_000
                readTimeout = 15_000
                doInput = true
                doOutput = true
                setRequestProperty("Authorization", "Bearer $token")
                setRequestProperty("Content-Type", "application/json")
                setRequestProperty("Accept", "application/json")
            }

            try {
                BufferedWriter(OutputStreamWriter(connection.outputStream, Charsets.UTF_8)).use { writer ->
                    writer.write(requestBody?.toString() ?: "{}")
                    writer.flush()
                }

                val responseCode = connection.responseCode
                val success = responseCode in 200..299
                if (!success) {
                    Log.w(
                        TAG,
                        "Native offer action failed: path=$path code=$responseCode message=${connection.responseMessage}",
                    )
                } else {
                    Log.d(TAG, "Native offer action succeeded: path=$path code=$responseCode")
                }
                onComplete?.invoke(success)
            } catch (error: Throwable) {
                Log.e(TAG, "Native offer action request failed: path=$path", error)
                onComplete?.invoke(false)
            } finally {
                connection.disconnect()
            }
        }
    }

    private fun readAccessToken(): String {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val isSaved = prefs.getBoolean(IS_ACCESS_TOKEN_SAVED_KEY, false)
        if (!isSaved) {
            return ""
        }
        return prefs.getString(ACCESS_TOKEN_KEY, null)?.trim().orEmpty()
    }
}
