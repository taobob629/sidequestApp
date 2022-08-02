import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/model/promotion_item_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/navigator_helper.dart';

class PopAdDialog extends StatelessWidget {

  final PromotionItemModel model;
  final File image;

  PopAdDialog({required this.model,required this.image});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
        child: GestureDetector(
          onTap: () {
            UserController userController = Get.find<UserController>();
            if(userController.user.value.id != 0) {
              IndexApi.readAD(model.id, model.title);
            }
            Get.back();
            NavigatorHelper.gotoConfigTarget(model.content);
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(image,
                  width: width,
                  height: width,
                  fit: BoxFit.fitWidth,),
                SizedBox(height: 50,),
                _buildCloseButton()
              ],
            ),
          )
        )
      ),
    );
  }

  Widget _buildCloseButton(){
    return GestureDetector(
      onTap: ()=> Get.back(),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white,width: 1)
        ),
        child: Center(
          child: Icon(Icons.clear,size: 26,color: Colors.white,),
        ),
      ),
    );
  }

  static Future<bool?> show(BuildContext context, PromotionItemModel model, File image, {bool cancelable = true}) async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black26,
      barrierDismissible: cancelable,
      builder: (BuildContext context) {
        return PopAdDialog(model: model,image: image,);
      }
    );
  }
}