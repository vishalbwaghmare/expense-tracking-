import 'package:flutter/services.dart';

class BlutoothService {
  // Use a stable channel name shared with the native side implementation.
  static const MethodChannel _channel = MethodChannel(
    'expense_tracker/bluetooth',
  );

  /// Cached initial status that can be set at app startup to allow
  /// immediate UI rendering before the first async platform call completes.
  static bool? initialStatus;

  /// Returns true when Bluetooth is enabled on the device.
  ///
  /// NOTE: You must implement the native platform handler for the
  /// 'isBluetoothEnabled' method on Android/iOS to return a boolean.
  static Future<bool> isBluetoothEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isBluetoothEnabled');
      return result == true;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
