import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

showLoading() {
  SmartDialog.showLoading(maskColor: Colors.transparent);
}

dismissLoading() {
  SmartDialog.dismiss();
}

showToast(var msg, {Duration? duration}) {
  SmartDialog.showToast(msg, displayTime: duration);
}

showSuccess(var msg, {Duration? duration}) {
  return SmartDialog.showNotify(
    msg: msg,
    notifyType: NotifyType.success,
    displayTime: duration,
  );
}

showInfo(var msg, {Duration? duration}) {
  SmartDialog.showNotify(
    msg: msg,
    notifyType: NotifyType.warning,
    animationTime: duration,
  );
}

showError(var msg, {Duration? duration}) {
  SmartDialog.showNotify(
    msg: msg,
    notifyType: NotifyType.error,
    displayTime: duration,
  );
}
