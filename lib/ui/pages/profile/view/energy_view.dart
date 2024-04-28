import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../utils/navigator_helper.dart';

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
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                ImageUtils.profile_energy_w_icon,
                height: 70.h,
                fit: BoxFit.fill,
              ),
              Image.asset(
                ImageUtils.profile_energy_w_icon,
                height: 70.h,
                fit: BoxFit.fill,
              ),
            ],
          ),
          Row(
            children: _buildEnergyList(num),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEnergyList(int num) {
    int full = (num * percent).round();
    List<Widget> energyList = [];

    energyList.add(15.horizontalSpace);

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
            16.verticalSpace,
            energyRow,
            6.verticalSpace,
            RichText(
              text: TextSpan(
                  text: "Remaining game times：",
                  style: TextStyle(
                    color: hexColor('808388'),
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                  ),
                  children: [
                    TextSpan(
                      text: "${UserController.find.userProfile.avamins} mins",
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
    energyList.add(10.horizontalSpace);

    energyList.add(
      Transform.translate(
        offset: Offset(0, -14.h),
        child: Image.asset(
          ImageUtils.energy_right_icon,
          width: 70.w,
          height: 90.w,
        ),
      ),
    );
    return energyList;
  }

  Widget _buildEnergy(bool full) {
    return Stack(
      children: [
        Image.asset(
          ImageUtils.energy_empty,
          fit: BoxFit.fill,
          width: 10.w,
          height: 18.h,
        ),
        full
            ? Image.asset(
                ImageUtils.energy_full,
                fit: BoxFit.contain,
                width: 10.w,
                height: 18.h,
              )
            : Container()
      ],
    );
  }
}
