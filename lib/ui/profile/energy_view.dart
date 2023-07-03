import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/utils/index.dart';

class EnergyView extends StatelessWidget {
  final double percent;
  final int remaining;
  final double width;
  late final String remainingText;

  EnergyView({required this.percent, required this.remaining,this.width=200}) {
    if (remaining >= 60) {
      remainingText = "${(remaining / 60).toStringAsFixed(2)} H";
    } else {
      remainingText = "$remaining ${'Mins'.tr}";
    }
  }

  @override
  Widget build(BuildContext context) {
    int num = ((width-25.w) / 10.w).round();//显示的个数
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
    energyList.add(Container(
        width: 25.w,
        height: 25.w,
        child: Image.asset("assets/images/ic_battery.png", fit: BoxFit.contain)));
    for (int i = 0; i < num; i++) {
      energyList.add(_buildEnergy(i < full));
    }
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
