import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/model/promotion_item_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/toast_utils.dart';

class PopAdDialog extends StatelessWidget {
  final PromotionItemModel model;
  final File image;

  PopAdDialog({required this.model, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
        child: GestureDetector(
            onTap: () {
              UserController userController = Get.find<UserController>();
              if (userController.user.value.id != 0) {
                IndexApi.readAD(model.id, model.title);
              }
              Get.back();
              NavigatorHelper.gotoConfigTarget(model.content);
            },
            child: Center(
              child: Stack(
                children: [
                  Image.file(
                    image,
                    fit: BoxFit.contain,
                    width: 1.sw - 30.w,
                  ),
                  50.verticalSpace,
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: _buildCloseButton(),
                  ),
                ],
              ),
            )));
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Color(0x80000000),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Icon(
            Icons.clear,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Future<bool?> show(
      BuildContext context, PromotionItemModel model, File image,
      {bool cancelable = true}) async {
    return await showCustom(
      PopAdDialog(
        model: model,
        image: image,
      ),
      clickMaskDismiss: true,
      alignment: Alignment.center,
    );
  }
}
