import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/im_api.dart';

import '../common/colorful_button.dart';
import '../common/wy_dialog.dart';

class CommentDialog extends StatelessWidget {

  late final CommentDialogController controller;
  ///拒绝订单
  final bool isRehect;

  ///退款订单
  final bool isRefund;

  CommentDialog(int orderId, Function onDone,{ this.isRehect=false,this.isRefund=false}){
    controller = Get.put(
        CommentDialogController(
            orderId: orderId,
            onDone: onDone,
            isReject: isRehect,
            isRefund: isRefund),
        tag: '$orderId$isRefund$isRehect');
  }

  @override
  Widget build(BuildContext context) {
    var title = "Comment".tr;
    var hintText = "Input your comment".tr;
    if (isRehect) {
      hintText = "Input your reasons for refusal".tr;
      title = "Reject Order".tr;
    }
    if (isRefund) {
      title = "Refund".tr;
      hintText = "Input your refund reason".tr;
    }
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title == 'Comment'.tr)
                SizedBox(
                  height: 20,
                ),
              if (title == 'Comment'.tr)
                FFStars(
                  normalStar: Image.asset("assets/images/play/score0.png"),
                  selectedStar: Image.asset("assets/images/play/score1.png"),
                  starsChanged: (realStars, selectedStars) {
                    controller.star = realStars;
                  },
                  step: 0.01,
                  defaultStars: 5,
                  miniStars: 1,
                  starHeight: 20,
                  starWidth: 20,
                starMargin: 16,
                followChange: true,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white10
                ),
                child: TextField(
                  maxLines: 1,
                  controller: controller.commentController,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onSubmitted: (text) => {},
                  decoration: InputDecoration(
                    hintText:hintText,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 0)
                  ),
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
            onTap: () => controller.comment()
          )
        ],
      ),
    );
  }

}

class CommentDialogController extends GetxController{
  late TextEditingController commentController;

  late int orderId;
  late bool isReject;
  late bool isRefund;

  late Function onDone;

  double star = 5.0;

  CommentDialogController({required this.orderId, required this.onDone,required this.isReject,required this.isRefund});

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

  void comment() async{
    EasyLoading.show();
    if(isReject){
      var res = await ImApi.rejectOrder(orderId.toString(), commentController.text).catchError((v){});
      if(res!=null){
        EasyLoading.showToast('${res.statusMessage}');
      }
    }else if(isRefund){
      var res = await ImApi.refundOrder(orderId.toString(), commentController.text).catchError((v){});
      if(res!=null){
        EasyLoading.showToast('${res.statusMessage}');
      }
    }else{
      await ImApi.finishOrder(orderId.toString(), star, commentController.text);
    }
    EasyLoading.dismiss();
    Get.back();
    onDone.call();
  }


}