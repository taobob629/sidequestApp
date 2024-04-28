import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../api/wy_http.dart';
import '../../../../utils/toast_utils.dart';
import '../../dialog/dialog_confirm.dart';

class MoreFunWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map map = Get.arguments as Map;
    String nickName = map['nickName'];
    int id = map['id'];
    int pwId = map['pwId'];

    Offset offset = map['offset'];
    bool ifUp = (Get.height - offset.dy) < 200;

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: ifUp
              ? offset.dy - MediaQuery.of(Get.context!).padding.top - 13
              : offset.dy - MediaQuery.of(Get.context!).padding.top + 15,
          left: offset.dx - 10,
          child: ClipPath(
            clipper: UpDownTriangle(dir: -1, ifUp: ifUp),
            child: Container(
              width: 20.0,
              height: 10.0,
              color: Color(0xff282640),
            ),
          ),
        ),
        Positioned(
          top: ifUp
              ? offset.dy - MediaQuery.of(Get.context!).padding.top - 105
              : offset.dy - MediaQuery.of(Get.context!).padding.top + 15 + 10,
          width: Get.width - 30.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            decoration: BoxDecoration(
                color: Color(0xff282640),
                borderRadius: BorderRadius.circular(10.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.dialog(ConfirmDialog(
                    title: 'Confirm'.tr,
                    info: 'After blocking the user, you will no longer see any posts from them.'.tr,
                    onConfirm: () async {
                      showLoading();
                      final result = await http.get(
                          '/peiwan/app/posts/block?id=$id&&pwid=$pwId');
                      dismissLoading();
                      if (result.data != null) {
                        if (result.data['code'] == 200) {
                          showToast('Block Successful');
                          Get.back(result: true);
                        } else {
                          showToast(result.data['msg']);
                        }
                      } else {
                        if (result.statusCode == 200) {
                          showToast(result.statusMessage);
                          Get.back(result: true);
                        } else {
                          showToast(result.data['msg']);
                        }
                      }
                    },
                  )).then((value) => Get.back(result: true)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.block,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      10.horizontalSpace,
                      Text(
                        'Block user $nickName'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'din',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Get.width - 50.w,
                  height: 1.h,
                  color: Color(0xFF262731),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.dialog(ConfirmDialog(
                    title: 'Report violations or misconduct contents'.tr,
                    info: 'Are you sure you want to submit the report?'.tr,
                    confirmBtn: 'Submit Report',
                    onConfirm: () async {
                      showLoading();
                      final result = await http.get(
                          '/peiwan/app/posts/report?id=$id&&pwid=$pwId');
                      dismissLoading();
                      if (result.data != null) {
                        if (result.data['code'] == 200) {
                          showToast('Thank you for reporting the content. We will review it thoroughly to determine if it violates our guidelines. '.tr);
                          Get.back(result: true);
                        } else {
                          showToast(result.data['msg']);
                        }
                      } else {
                        if (result.statusCode == 200) {
                          showToast('Thank you for reporting the content. We will review it thoroughly to determine if it violates our guidelines. '.tr);
                          Get.back(result: true);
                        } else {
                          showToast(result.data['msg']);
                        }
                      }
                    },
                  )).then((value) => Get.back(result: true)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.report_gmailerrorred,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      10.horizontalSpace,
                      Text(
                        'Report violations or misconduct contents'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'din',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UpDownTriangle extends CustomClipper<Path> {
  double dir;
  bool ifUp;

  UpDownTriangle({
    required this.dir,
    required this.ifUp,
  });

  @override
  Path getClip(Size size) {
    var path = Path();

    if (ifUp) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
      path.close();
      return path;
    }

    double w = size.width;
    double h = size.height;
    if (dir < 0) {
      path.moveTo(w / 2, 0);
      path.quadraticBezierTo(w / 2, 0, 0, h);
      path.quadraticBezierTo(0, h, w, h);
    } else {
      path.quadraticBezierTo(0, h / 2, w * 2 / 3, h);
      path.quadraticBezierTo(w / 3, h / 3, w, 0);
      path.lineTo(0, 0);
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
