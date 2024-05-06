import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TipsDialog extends StatelessWidget {
  TipsDialog({Key? key, required this.offset, required this.tips}) : super(key: key);
  final Offset offset;
  final String tips;

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
          width: Get.width - offset.dx / 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(color: Color(0xff282640), borderRadius: BorderRadius.circular(10)),
            child: Text(
              tips,
              style: TextStyle(color: Color(0xff8291B4), height: 1.5),
            ),
            // child: PWidget.container(
            //   PWidget.column([
            //     PWidget.text('Withdrawal and exchange instructions:'.tr, [Color(0xffEEF3FF)]),
            //     Text(
            //       '''1. ${'Withdrawals typically take three to five bank working days.'.tr}\n2. ${'6 Diamond for £1.'.tr}\n3. ${'If you withdraw cash from us, you’ll be charged a handling fee of 3%.'.tr}''',
            //       style: TextStyle(color: Color(0xff8291B4), height: 1.5),
            //     ),
            //   ]),
            //   {'pd': 16},
            // ),
          ),
        ),
      ],
    );
  }
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
