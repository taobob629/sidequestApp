import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../api/common.dart';
import '../../../../image_utils.dart';
import '../../../../utils/image_util.dart';
import '../../../../utils/permission_helper.dart';
import '../../../controller/user_controller.dart';
import '../../../profile/edit/crop_page.dart';

class SelectAvatarDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: Get.width,
        height: 300.h,
        decoration: ShapeDecoration(
          color: Color(0xFF262731),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
        ),
        padding: EdgeInsets.only(
          top: 15.h,
          left: 10.w,
          right: 10.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload avatar, showcase yourself',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
            30.verticalSpace,
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.r),
                child: ImageUtil.networkImage(
                  url: UserController.find.userProfile.avatar,
                  width: 66.w,
                  height: 66.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            15.verticalSpace,
            Center(
              child: Text(
                UserController.find.userProfile.nickName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 18.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              )
            ),
            40.verticalSpace,
            // GestureDetector(
            //   onTap: () => dismissLoading(),
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 15.w),
            //     width: Get.width,
            //     height: 46.h,
            //     decoration: ShapeDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment(-1.00, 0.00),
            //         end: Alignment(1, 0),
            //         colors: [Color(0xFFFF760E), Color(0xFFFFB20E)],
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(60.r),
            //       ),
            //     ),
            //     alignment: Alignment.center,
            //     child: Text(
            //       'Use default avatar'.tr,
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16.sp,
            //         fontWeight: FontWeight.w400,
            //         fontFamily: FONT_MEDIUM,
            //       ),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () => selectUpdateAvatar(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                width: Get.width,
                height: 46.h,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFFFB20E)),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Select from album'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              )
            ),
          ],
        ),
      );

  void selectUpdateAvatar() async {
    dismissLoading();
    var status = await PermissionHelper.requestPhotosPermission(Get.context!);
    if (status == false) {
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        if (value != null) {
          showLoading();
          await Common.uploadAvatar(value!, (p0, p1) {});
          dismissLoading();
          UserController.find.updateInfo();
        }
      });
    } else {
      print('No image selected.');
    }
  }
}
