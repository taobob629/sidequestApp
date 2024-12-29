import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/icon_font.dart';

class AddRuleDialog extends StatelessWidget {
  AddRuleDialog({Key? key, required this.offset}) : super(key: key);
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15,
          left: offset.dx - 10,
          child: ClipPath(
            clipper: Triangle(dir: -1),
            child: Container(
              width: 20.0,
              height: 10.0,
              color: Color(0xff282640),
              child: null,
            ),
          ),
        ),
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15 + 10,
          width: 1.sw,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 15.h,
            ),
            decoration: BoxDecoration(
              color: Color(0xff282640),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    children: [
                      tipContentWidget(
                        "Level",
                        "Discount",
                        "Combo Limit",
                        "Connections Limit",
                      ),
                      Container(color: Colors.white, height: 1.w),
                      tipContentWidget(
                        "Level 1",
                        "5%",
                        "2",
                        "2",
                      ),
                      Container(color: Colors.white, height: 1.w),
                      tipContentWidget(
                        "Level 2",
                        "10%",
                        "2",
                        "5",
                      ),
                      Container(color: Colors.white, height: 1.w),
                      tipContentWidget(
                        "Level 3",
                        "15%",
                        "3",
                        "8",
                      ),
                      Container(color: Colors.white, height: 1.w),
                      tipContentWidget(
                        "Level 4",
                        "20%",
                        "3",
                        "10",
                      ),
                      Container(color: Colors.white, height: 1.w),
                      tipContentWidget(
                        "Level 5",
                        "25%",
                        "4",
                        "12",
                      ),
                      Container(color: Colors.white, height: 1.w),
                      tipContentWidget(
                        "Level 6",
                        "30%",
                        "4",
                        "15",
                      ),
                    ],
                  ),
                ),
                Text(
                  "You are able to change your connection once a month.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ).paddingOnly(top: 10.h, bottom: 4.h),
                Text(
                  "You will get the maximum Combo discount from you connections",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget tipContentWidget(
    String name,
    String name2,
    String name3,
    String name4,
  ) =>
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.w,
                  ),
                ),
              ),
              height: 30.h,
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: FONT_MEDIUM,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.w,
                  ),
                ),
              ),
              height: 30.h,
              alignment: Alignment.center,
              child: Text(
                name2,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: FONT_MEDIUM,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.white,
                    width: 1.w,
                  ),
                ),
              ),
              height: 30.h,
              alignment: Alignment.center,
              child: Text(
                name3,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: FONT_MEDIUM,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              name4,
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: FONT_MEDIUM,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}

class Triangle extends CustomClipper<Path> {
  double dir;

  Triangle({required this.dir});

  @override
  Path getClip(Size size) {
    var path = Path();

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
