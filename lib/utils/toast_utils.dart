import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

showLoading({String msg = 'loading...', bool clickMaskDismiss = true}) {
  SmartDialog.showLoading(
    msg: msg,
    maskColor: Colors.transparent,
    clickMaskDismiss: clickMaskDismiss,
  );
}

dismissLoading() {
  SmartDialog.dismiss();
}

showToast(var msg, {Duration? duration}) async {
  return await SmartDialog.showToast(msg, displayTime: duration);
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

showCustom(
  Widget widget, {
  bool clickMaskDismiss = true,
  AlignmentGeometry? alignment,
  bool? backDismiss,
  Color? maskColor,
  // 点击事件是否穿透
  bool usePenetrate = false,
  VoidCallback? onDismiss,
}) async {
  return await SmartDialog.show(
    builder: (builder) => widget,
    clickMaskDismiss: clickMaskDismiss,
    maskColor: maskColor,
    usePenetrate: usePenetrate,
    onDismiss: onDismiss,
    backDismiss: backDismiss,
  );
}
