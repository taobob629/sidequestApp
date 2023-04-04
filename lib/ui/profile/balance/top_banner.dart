import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/controller/user_controller.dart';

import 'count_view.dart';

class TopBanner extends StatelessWidget {

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15,right: 15,),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFFF3BC1)
      ),
      child: AspectRatio(
        aspectRatio: 343/136,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: ClipPath(
                clipper: _BottomPath(),
                child: Container(
                  color: Colors.white30,
                )
              )
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: ClipPath(
                clipper: _Bottom2Path(),
                child: Container(
                  color: Colors.white30,
                )
              )
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xaaFF3BC2),Color(0x998B00FF)]
                )
              ),
            ),
            Positioned(
              right: 0,
              top: -10,
              width: 100,
              child: Image.asset("assets/images/bg_balance.webp")
            ),
            Obx(()=>Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                    CountView(
                      customIcon: 'assets/images/ic_corns_new.webp',
                      icon: "money",
                      title: "Credits Balance".tr,
                      count: "${userController.userProfile.balance}",
                    ),
                    CountView(
                      icon: "time",
                      title: "Free Gaming Time".tr,
                      count: "${userController.userProfile.avamins}",
                    )
                  ],
            ))
          ],
        ),
      ),
    );
  }
}

class _BottomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint;
    var endPoint;
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(-size.width * 5 / 100, size.height * 70 / 100);

    controlPoint=Offset(size.width * 5 / 100, size.height * 80 / 100);  //曲线开始点
    endPoint=Offset(size.width * 20 / 100, size.height * 45 / 100 ); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
      endPoint.dx, endPoint.dy);

    controlPoint=Offset(size.width * 38 / 100, 0);  //曲线开始点
    endPoint=Offset(size.width * 60 / 100, size.height * 55 / 100 ); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
      endPoint.dx, endPoint.dy);

    controlPoint=Offset(size.width * 80 / 100 , size.height);  //曲线开始点
    endPoint=Offset(size.width, size.height * 75 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
      endPoint.dx, endPoint.dy);

    path.lineTo(size.width,size.height);  // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _Bottom2Path extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 55 / 100);
    path.cubicTo(size.width*322/700, 0, size.width*382/700, size.height*1.3, size.width, size.height * 60 / 100);
    path.lineTo(size.width,size.height);  // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}