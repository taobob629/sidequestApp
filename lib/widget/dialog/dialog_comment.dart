import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/wy_dialog.dart';
import 'package:wy/utils/toast_utils.dart';

class DialogComment extends StatelessWidget {
  Function(String)? onConfirm;
  String? hint;
  String? title;

  DialogComment({this.onConfirm, this.hint = '', this.title});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('${title ?? "Comment".tr}', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10).r,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16).r, color: Colors.white10),
                child: TextField(
                  minLines: 5,
                  maxLines: 10,
                  controller: controller,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onSubmitted: (text) => {},
                  decoration: InputDecoration(
                      hintText: '${hint ?? "Input your comment".tr}',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 0)),
                ),
              ),
            ],
          ),
          ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "COMMIT".tr,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                ),
              ),
              height: 40,
              onTap: () {
                var text = controller.text;
                if (text.isEmpty) {
                  showToast(hint ?? 'please input');
                  return;
                }
                onConfirm?.call(text);
                Get.back();
              })
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

  void comment() async {
    showLoading();
    if (isReject) {
      var res =
          await ImApi.rejectOrder(orderId.toString(), commentController.text).catchError((v) {});
      dismissLoading();
      if (res != null) {
        showToast('${res.statusMessage}');
      }
    } else if (isRefund) {
      var res =
          await ImApi.refundOrder(orderId.toString(), commentController.text).catchError((v) {});
      dismissLoading();
      if (res != null) {
        showToast('${res.statusMessage}');
      }
    } else {
      await ImApi.finishOrder(orderId.toString(), star, commentController.text);
      dismissLoading();
    }
    Get.back();
    onDone.call();
  }
}
