import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/utils/platform_utils.dart';

class PermissionHelper {
  static bool isDenied(PermissionStatus status) {
    if (Platform.isAndroid) {
      if (status.isPermanentlyDenied) {
        return true;
      }
    } else {
      if (status.isDenied) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> requestCameraPermission(BuildContext context) async {
    var status = await Permission.camera.request();
    if (isDenied(status)) {
      var ret = await ConfirmDialog.show(context, "Permission required",
          "Your camera is not available, please click the button below to change current setting.");
      if (ret == true) {
        await openAppSettings();
      }
      return false;
    } else if (status.isDenied) {
      return false;
    }
    return true;
  }

  static Future<bool> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.request();
    if (isDenied(status)) {
      var ret = await ConfirmDialog.show(
          context,
          "Permission required",
          "Your Location is not available, please click the button below to change current setting."
              .tr);
      if (ret == true) {
        await openAppSettings();
      }
      return false;
    } else if (status.isDenied) {
      return false;
    }
    return true;
  }

  static Future<bool> requestPhotosPermission(BuildContext context) async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    if (isDenied(status)) {
      var ret = await ConfirmDialog.show(context, "Permission required","Your photos is not available, please click the button below to change current setting.");
      if (ret == true) {
        await openAppSettings();
      }
      return false;
    } else if (status.isDenied) {
      return false;
    }
    return true;
  }
}