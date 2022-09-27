import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/im_api.dart';

import '../common/colorful_button.dart';
import '../common/wy_dialog.dart';

class CommentDialog extends StatelessWidget {

  late final CommentDialogController controller;

  CommentDialog(int orderId, Function onDone){
    controller = Get.put(CommentDialogController(orderId:orderId, onDone:onDone));
  }

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Comment", style: TextStyle(fontSize: 16, color: Colors.white),),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              FFStars(
                normalStar: Image.asset("assets/images/play/score0.png"),
                selectedStar: Image.asset("assets/images/play/score1.png"),
                starsChanged: (realStars, selectedStars) {
                  controller.star = realStars;
                },
                step: 0.01,
                defaultStars: 4,
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
                    hintText: "Input your comment",
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
              child: Text("COMMIT", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),),
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

  late Function onDone;

  double star = 4.0;

  CommentDialogController({required this.orderId, required this.onDone});

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
    await ImApi.finishOrder(orderId.toString(), star, commentController.text);
    EasyLoading.dismiss();
    Get.back();
    onDone.call();
  }


}