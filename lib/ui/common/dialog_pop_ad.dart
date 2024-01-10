import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

  PopAdDialog({required this.model});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: width,
        height: width / 0.8,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: GestureDetector(
          onTap: () {
            UserController userController = Get.find<UserController>();
            if (userController.user.value.id != 0) {
              IndexApi.readAD(model.id, model.title);
            }
            dismissLoading();
            NavigatorHelper.gotoConfigTarget(model.content);
          },
          child: Stack(
            children: [
              Image.network(
                model.image,
                fit: BoxFit.contain,
              ),
              Positioned(
                right: 10.w,
                top: 10.h,
                child: _buildCloseButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => dismissLoading(),
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

  static Future<bool?> show(BuildContext context, PromotionItemModel model,
      {bool cancelable = true}) async {
    return await showCustom(
      PopAdDialog(
        model: model,
      ),
      clickMaskDismiss: true,
      alignment: Alignment.center,
    );
  }
}
