import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

showLoading({String msg = 'loading...', bool clickMaskDismiss = true}) {
  SmartDialog.showLoading(
    msg: msg,
    maskColor: Colors.transparent,
    clickMaskDismiss: clickMaskDismiss,
  );
}

dismissLoading({
  var result,
  SmartStatus status = SmartStatus.smart,
  String? tag,
}) async {
  SmartDialog.dismiss(result: result, status: status, tag: tag);
}

showToast(var msg, {Duration? duration}) async {
  return await SmartDialog.showToast(
    msg,
    displayTime: duration,
    alignment: Alignment.center,
  );
}

showSuccess(var msg, {Duration? duration}) {
  return SmartDialog.showNotify(
    msg: msg,
    notifyType: NotifyType.success,
    displayTime: duration,
  );
}

showInfo(var msg, {Duration? duration}) {
  return SmartDialog.showToast(
    msg.toString(),
    alignment: Alignment.topCenter,
    displayTime: duration ?? const Duration(seconds: 3),
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.paddingOf(context).top + 12,
        16,
        0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xF5222226),
            border: Border.all(color: const Color(0x66FFB20E)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x59000000),
                offset: Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 11, 15, 11),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0x1FFFb20E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFFFB20E),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    msg.toString(),
                    style: const TextStyle(
                      color: Color(0xFFF4F3F5),
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
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
  String? tag,
  Alignment? alignment,
  bool? backDismiss,
  Color? maskColor,
  // 点击事件是否穿透
  bool usePenetrate = false,
  VoidCallback? onDismiss,
}) async {
  return await SmartDialog.show(
    builder: (builder) => widget,
    clickMaskDismiss: clickMaskDismiss,
    tag: tag,
    alignment: alignment,
    maskColor: maskColor,
    usePenetrate: usePenetrate,
    onDismiss: onDismiss,
    backDismiss: backDismiss,
  );
}

showAttach(
  Widget widget, {
  required BuildContext targetContext,
  bool clickMaskDismiss = true,
  Alignment? alignment,
  Color? maskColor,
}) async {
  return SmartDialog.showAttach(
    builder: (builder) => widget,
    clickMaskDismiss: clickMaskDismiss,
    alignment: alignment,
    targetContext: targetContext,
    maskColor: maskColor,
  );
}
