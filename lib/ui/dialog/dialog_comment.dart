import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colorful_button.dart';
import '../../common/wy_dialog.dart';
import '../../utils/toast_utils.dart';

class DialogComment extends StatelessWidget {
  Function(String)? onConfirm;
  String? hint;
  String? title;
  int minLines;
  int maxLines;
  bool autoClose; //confirm会自动关掉
  bool obscureText;

  DialogComment({
    this.onConfirm,
    this.hint = '',
    this.title,
    this.minLines = 5,
    this.maxLines = 10,
    this.autoClose = true,
    this.obscureText = false,
  });

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title ?? "Comment".tr,
              style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10).r,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16).r,
                    color: Colors.white10),
                child: TextField(
                  minLines: minLines,
                  maxLines: maxLines,
                  controller: controller,
                  obscureText: obscureText,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onSubmitted: (text) => {},
                  decoration: InputDecoration(
                      hintText: hint ?? "Input your comment".tr,
                      hintStyle:
                          TextStyle(fontSize: 14.sp, color: Colors.white24),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(bottom: 0)),
                ),
              ),
            ],
          ),
          ColorfulButton(
              height: 40,
              onTap: () {
                var text = controller.text;
                if (text.isEmpty) {
                  showToast(hint ?? 'please input');
                  return;
                }
                onConfirm?.call(text);
                if (autoClose) Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "COMMIT".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: "DIN",
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class CommentDialogController extends GetxController {
  late TextEditingController commentController;

  late int orderId;
  late bool isReject;
  late bool isRefund;

  late Function onDone;

  double star = 5.0;

  CommentDialogController(
      {required this.orderId,
      required this.onDone,
      required this.isReject,
      required this.isRefund});

  @override
  void onInit() {
    super.onInit();
    commentController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
  }
}
