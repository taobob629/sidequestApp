import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sq_hub_app/ui/pages/profile/my_profile/profile_edit_page.dart';

import '../../../../../api/common.dart';
import '../../../../../utils/permission_helper.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../utils/toast_utils.dart';
import '../crop_page.dart';

class SelectAvatarDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        height: 1.sh,
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 1.sw,
          height: 340.h,
          decoration: ShapeDecoration(
            color: const Color(0xFF262731),
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
                'Upload your profile image',
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
                  child: ExtendedImage.network(
                    UserController.find.userProfile.avatar,
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
                ),
              ),
              30.verticalSpace,
              GestureDetector(
                onTap: () {
                  dismissLoading();
                  Get.to(() => ProfileEditPage());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  width: Get.width,
                  height: 46.h,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-1.00, 0.00),
                      end: Alignment(1, 0),
                      colors: [Color(0xFFFF760E), Color(0xFFFFB20E)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Edit your profile'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
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
                  )),
            ],
          ),
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
          await Common.uploadAvatar(value, (p0, p1) {});
          dismissLoading();
          UserController.find.updateInfo();
        }
      });
    } else {
      print('No image selected.');
    }
  }
}
