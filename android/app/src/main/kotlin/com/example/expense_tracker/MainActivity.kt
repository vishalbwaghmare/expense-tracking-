package com.example.expense_tracker

import android.bluetooth.BluetoothAdapter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "expense_tracker/bluetooth"
        private const val METHOD_IS_BLUETOOTH_ENABLED = "isBluetoothEnabled"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == METHOD_IS_BLUETOOTH_ENABLED) {
                val adapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
                val isEnabled = adapter?.isEnabled ?: false
                result.success(isEnabled)
            } else {
                result.notImplemented()
            }
        }
    }
}
