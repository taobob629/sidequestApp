import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/index.dart';

class EnergyView extends StatelessWidget {
  final double percent;
  final int remaining;
  final double width;
  late final String remainingText;

  EnergyView(
      {required this.percent, required this.remaining, this.width = 200}) {
    if (remaining >= 60) {
      remainingText = "${(remaining / 60).toStringAsFixed(2)} H";
    } else {
      remainingText = "$remaining ${'Mins'.tr}";
    }
  }

  @override
  Widget build(BuildContext context) {
    int num = ((width - 25.w) / 10.w).round(); //显示的个数
    flog('num$num');
    return GestureDetector(
      onTap: () {
        NavigatorHelper.gotoCouponPage(couponType: 5);
      },
      child: Row(
        children: _buildEnergyList(num),
      ),
    );
  }

  List<Widget> _buildEnergyList(int num) {
    int full = (num * percent).round();
    List<Widget> energyList = [];

    energyList.add(6.horizontalSpace);

    List<Widget> energyWidgets = [];
    for (int i = 0; i < num; i++) {
      energyWidgets.add(Expanded(child: _buildEnergy(i < full)));
    }

    Widget energyRow = Row(
      children: energyWidgets,
    );

    energyList.add(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            energyRow,
            10.verticalSpace,
            RichText(
              text: TextSpan(
                  text: "Remaining game times：",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                  ),
                  children: [
                    TextSpan(
                      text: "${UserController.find.userProfile.avamins} hours",
                      style: TextStyle(
                        color: hexColor('FFCB0D'),
                        fontSize: 12.sp,
                        fontFamily: FONT_LIGHT,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
    energyList.add(
      Image.asset(
        ImageUtils.energy_right_icon,
        width: 90.w,
        height: 90.w,
      ),
    );
    return energyList;
  }

  Widget _buildEnergy(bool full) {
    return Container(
      width: 10,
      height: 21.h,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/energy_empty.webp",
            fit: BoxFit.contain,
            color: hexColor('FFED5B'),
          ),
          full
              ? Image.asset(
                  "assets/images/energy_full.webp",
                  fit: BoxFit.contain,
                )
              : Container()
        ],
      ),
    );
  }
}
