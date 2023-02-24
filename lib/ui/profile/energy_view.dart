import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/utils/index.dart';

import '../../utils/navigator_helper.dart';

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
    int num = (width / 10.w).ceil();
    flog('num$num');
    return GestureDetector(
      onTap: () {
        NavigatorHelper.gotoCouponPage(couponType: 5);
      },
      child: Container(
          // height: 42,
         padding: EdgeInsets.only(left: 10,right: 5).r,
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 4),
              //       child: Text("Free Gaming Time".tr,
              //           style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: "DIN")),
              //     ),
              //     Spacer(),
              //     Padding(
              //       padding: const EdgeInsets.only(top: 5, right: 10),
              //       child: Text("${'Remaining'.tr}: $remainingText",
              //           style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: "DIN")),
              //     ),
              //   ],
              // ),
              Row(
                children: _buildEnergyList(num),
              ),
            ],
          )),
    );
  }

  List<Widget> _buildEnergyList(int num) {
    int full = (num * percent).round();
    List<Widget> energyList = [];
    energyList.add(Container(
        width: 25,
        height: 25,
        child: Image.asset("assets/images/ic_battery.png", fit: BoxFit.contain)));
    for (int i = 0; i < num; i++) {
      energyList.add(_buildEnergy(i < full));
    }
    return energyList;
  }

  Widget _buildEnergy(bool full) {
    return Container(
      width: 10,
      height: 21,
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
