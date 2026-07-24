package com.zadana.delivery

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

object NotificationApiService {
    private const val TAG = "NotificationApi"
    private const val PREFS_NAME = "FlutterSharedPreferences"
    private const val TOKEN_KEY = "flutter.accessToken"
    private const val BASE_URL_KEY = "flutter.baseUrl"
    private const val DEFAULT_BASE_URL = "https://api.zadna0.com/api"

    suspend fun acceptOffer(context: Context, assignmentId: String): ApiResult {
        return withContext(Dispatchers.IO) {
            try {
                val token = getToken(context)
                if (token.isNullOrEmpty()) {
                    Log.e(TAG, "Accept failed: No auth token found")
                    return@withContext ApiResult.Error("لا يوجد توكن مصادقة")
                }

                val baseUrl = getBaseUrl(context)
                val urlString = "$baseUrl/drivers/offers/$assignmentId/accept"
                Log.d(TAG, "Accept offer request: URL=$urlString")
                
                val url = URL(urlString)
                val connection = url.openConnection() as HttpURLConnection

                connection.apply {
                    requestMethod = "POST"
                    setRequestProperty("Authorization", "Bearer $token")
                    setRequestProperty("Content-Type", "application/json")
                    setRequestProperty("Accept", "application/json")
                    connectTimeout = 15000
                    readTimeout = 15000
                    doOutput = false
                }

                Log.d(TAG, "Sending accept request...")
                val responseCode = connection.responseCode
                Log.d(TAG, "Accept offer response code: $responseCode")

                when (responseCode) {
                    in 200..299 -> {
                        val response = connection.inputStream.bufferedReader().use { it.readText() }
                        Log.d(TAG, "Accept offer success: $response")
                        connection.disconnect()
                        ApiResult.Success(response)
                    }
                    else -> {
                        val errorBody = try {
                            connection.errorStream?.bufferedReader()?.use { it.readText() }
                        } catch (e: Exception) {
                            null
                        }
                        Log.e(TAG, "Accept offer failed: $responseCode - $errorBody")
                        connection.disconnect()
                        ApiResult.Error(errorBody ?: "فشل قبول الطلب (HTTP $responseCode)")
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Accept offer exception", e)
                ApiResult.Error("خطأ في الاتصال: ${e.message}")
            }
        }
    }

    suspend fun rejectOffer(context: Context, assignmentId: String): ApiResult {
        return withContext(Dispatchers.IO) {
            try {
                val token = getToken(context)
                if (token.isNullOrEmpty()) {
                    Log.e(TAG, "Reject failed: No auth token found")
                    return@withContext ApiResult.Error("لا يوجد توكن مصادقة")
                }

                val baseUrl = getBaseUrl(context)
                val urlString = "$baseUrl/drivers/offers/$assignmentId/reject"
                Log.d(TAG, "Reject offer request: URL=$urlString")
                
                val url = URL(urlString)
                val connection = url.openConnection() as HttpURLConnection

                connection.apply {
                    requestMethod = "POST"
                    setRequestProperty("Authorization", "Bearer $token")
                    setRequestProperty("Content-Type", "application/json")
                    setRequestProperty("Accept", "application/json")
                    connectTimeout = 15000
                    readTimeout = 15000
                    doOutput = false
                }

                Log.d(TAG, "Sending reject request...")
                val responseCode = connection.responseCode
                Log.d(TAG, "Reject offer response code: $responseCode")

                when (responseCode) {
                    in 200..299 -> {
                        val response = connection.inputStream.bufferedReader().use { it.readText() }
                        Log.d(TAG, "Reject offer success: $response")
                        connection.disconnect()
                        ApiResult.Success(response)
                    }
                    else -> {
                        val errorBody = try {
                            connection.errorStream?.bufferedReader()?.use { it.readText() }
                        } catch (e: Exception) {
                            null
                        }
                        Log.e(TAG, "Reject offer failed: $responseCode - $errorBody")
                        connection.disconnect()
                        ApiResult.Error(errorBody ?: "فشل رفض الطلب (HTTP $responseCode)")
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Reject offer exception", e)
                ApiResult.Error("خطأ في الاتصال: ${e.message}")
            }
        }
    }

    private fun getToken(context: Context): String? {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val token = prefs.getString(TOKEN_KEY, null)
        Log.d(TAG, "Retrieved token from SharedPreferences: ${if (token != null) "present (${token.take(20)}...)" else "null"}")
        
        // Debug: Log all keys in SharedPreferences
        val allKeys = prefs.all.keys
        Log.d(TAG, "All SharedPreferences keys: $allKeys")
        
        return token
    }

    private fun getBaseUrl(context: Context): String {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getString(BASE_URL_KEY, null) ?: DEFAULT_BASE_URL
    }

    sealed class ApiResult {
        data class Success(val response: String) : ApiResult()
        data class Error(val message: String) : ApiResult()
    }
}
