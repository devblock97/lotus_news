
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

Future<bool> isRealDevice(BuildContext context) async {
  if (Theme.of(context).platform == TargetPlatform.android) {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    return androidDeviceInfo.isPhysicalDevice;
  }
  return true;
}