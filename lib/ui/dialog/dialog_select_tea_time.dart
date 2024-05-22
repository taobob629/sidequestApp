import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sq_hub_app/common/wy_dialog.dart';
import 'package:sq_hub_app/config/app_color.dart';

import '../../common/colorful_button.dart';

class DialogSelectTeaTime extends StatelessWidget {
  var selectHour = 0.obs;
  var selectMin = 0.obs;

  final int startHour;
  final int endHour;
  final int startMin;
  final int endMin;

  DialogSelectTeaTime({
    required this.startHour,
    required this.endHour,
    required this.startMin,
    required this.endMin,
  });

  @override
  Widget build(BuildContext context) {
    selectHour.value = startHour;
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
            child: Text(
              "PickUp At".tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Obx(() => NumberPicker(
                      value: selectHour.value,
                      minValue: startHour,
                      maxValue: endHour,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      selectedTextStyle: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 24.sp,
                      ),
                      onChanged: (value) => selectHour.value = value,
                      itemCount: 5,
                    )),
              ),
              Expanded(
                child: Obx(() => NumberPicker(
                      value: selectMin.value,
                      minValue: 0,
                      maxValue: 59,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      selectedTextStyle: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 24.sp,
                      ),
                      onChanged: (value) => selectMin.value = value,
                      itemCount: 5,
                      step: 5,
                    )),
              ),
            ],
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() => Container(
        height: 40.h,
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black12,
            ),
          ),
        ),
        child: ColorfulButton(
          onTap: () {},
          height: 40,
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              "CONFIRM".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: "DIN",
              ),
            ),
          ),
        ),
      );
}
