package com.rohit.synergy_client_flutter

import android.app.Activity
import android.view.inputmethod.BaseInputConnection
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.view.KeyEvent
import androidx.core.view.KeyEventDispatcher
import io.flutter.embedding.android.KeyData
import io.flutter.embedding.android.KeyboardManager

/** SynergyClientFlutterPlugin */
class SynergyClientFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "synergy_client_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "simulateKey") {
            try {
                val args = call.arguments as Map<*, *>
                val keyCode: Int = when (val keyCodeArg = args["keyCode"]) {
                    is Int -> keyCodeArg
                    is Long -> keyCodeArg.toInt()
                    else -> keyCodeArg.toString().toInt()
                }
                val isDown = args["isDown"] as Boolean
                val isRepeat = args["isRepeat"] as Boolean
                val repeatCount = args["repeatCount"] as Int
                activity?.let { simulateKey(it, keyCode, isDown, isRepeat, repeatCount) }
                result.success(null)
            } catch (e: Exception) {
                result.error("Error", e.message, null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun simulateKey(
        activity: Activity,
        keyCode: Int,
        isDown: Boolean,
        isRepeat: Boolean,
        repeatCount: Int = 0,
    ) {
        val inputConnection = BaseInputConnection(
            activity.window.decorView.rootView, true
        )
        val action = if (isDown) KeyEvent.ACTION_DOWN else KeyEvent.ACTION_UP
        val flags = if (isRepeat) KeyEvent.FLAG_LONG_PRESS else 0

        val keyEvent = KeyEvent(
            System.currentTimeMillis(),
            System.currentTimeMillis(),
            action,
            keyCode,
            repeatCount,
            0,
            0,
            0,
            flags
        )

        inputConnection.sendKeyEvent(keyEvent)
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
