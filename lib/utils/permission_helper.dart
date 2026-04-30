import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sq_hub_app/utils/platform_utils.dart';

import '../ui/dialog/dialog_confirm.dart';

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

  static Future<bool> _checkPhotosPermission() async {
    if (Platform.isAndroid) {
      try {
        PermissionStatus photosStatus = await Permission.photos.status;
        PermissionStatus storageStatus = await Permission.storage.status;
        PermissionStatus mediaImagesStatus = await Permission.photos.status;
        
        if (photosStatus.isGranted || storageStatus.isGranted || mediaImagesStatus.isGranted) {
          return true;
        }
      } catch (e) {
        print('Error checking photos permission: $e');
      }
    }
    PermissionStatus status = await Permission.photos.status;
    return status.isGranted;
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
    if (await _checkPhotosPermission()) {
      return true;
    }

    PermissionStatus status = PermissionStatus.denied;
    if (Platform.isAndroid) {
      try {
        status = await Permission.photos.request();
        if (status.isGranted) {
          return true;
        }
        status = await Permission.storage.request();
        if (status.isGranted) {
          return true;
        }
      } catch (e) {
        print('Error requesting photos permission: $e');
        var ret = await ConfirmDialog.show(context, "Permission required",
            "Please grant photos permission in Settings to select images from album.");
        if (ret == true) {
          await openAppSettings();
        }
        return false;
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isPermanentlyDenied) {
      var ret = await ConfirmDialog.show(context, "Permission required",
          "Your photos is not available, please click the button below to change current setting.");
      if (ret == true) {
        await openAppSettings();
      }
      return false;
    } else if (status.isDenied) {
      var ret = await ConfirmDialog.show(context, "Permission required",
          "Please grant photos permission in Settings to select images from album.");
      if (ret == true) {
        await openAppSettings();
      }
      return false;
    }
    return true;
  }

  static Future<bool> checkAndRequestPhotosPermission(BuildContext context) async {
    PermissionStatus status = await Permission.photos.status;
    if (status.isGranted) {
      return true;
    }
    return requestPhotosPermission(context);
  }
}
