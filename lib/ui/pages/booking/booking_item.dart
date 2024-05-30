import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/model/booking_model.dart';

import '../../../common/styles.dart';
import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../utils/time_utils.dart';
import '../../dialog/dialog_confirm.dart';

class BookingItem extends StatelessWidget {
  final BookingModel model;
  final Function(int) onCancel;

  BookingItem({required this.model, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: itemPaddingNormal,
      decoration: itemDecoration(),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${model.store}",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                    color: Colors.white),
              ),
              10.verticalSpace,
              Text(
                "${model.area}",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: FONT_LIGHT,
                    color: Color(0xFF808388)),
              ),
              10.verticalSpace,
              Row(
                children: [
                  // Icon(
                  //   model.done ? Icons.alarm_off : Icons.alarm,
                  //   color: model.done ? Colors.white54 : Colors.white,
                  //   size: 30,
                  // ),
                  Image.asset(
                    ImageUtils.ic_booking_time,
                    width: 10,
                    color: const Color(0xFF808388),
                  ),
                  5.horizontalSpace,
                  Text(
                    TimeUtils.getYYYYMMDDHHMM(
                        DateTime.fromMillisecondsSinceEpoch(model.time * 1000),
                        '-',
                        ':'),
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: FONT_MEDIUM,
                        color: AppColor.textYellow),
                  ),
                  10.horizontalSpace,
                  // Container(
                  //   height: 12,
                  //   margin: const EdgeInsets.symmetric(horizontal: 10),
                  //   decoration:
                  //       BoxDecoration(border: Border(left: BorderSide(color: Colors.white24))),
                  // ),
                  Image.asset(
                    ImageUtils.ic_booking_game,
                    width: 10,
                    color: Color(0xFF808388),
                  ),
                  3.horizontalSpace,
                  Text(
                    "${model.duration}H",
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: FONT_MEDIUM,
                        color: Color(0xFF45FF0E)),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Offstage(
            offstage: model.done,
            child: GestureDetector(
              onTap: () {
                Get.dialog(
                        ConfirmDialog(
                            title: "Cancel Confirm".tr,
                            info: "Do you confirm to cancel this booking?".tr),
                        barrierColor: Colors.black26)
                    .then((value) {
                  if (value != null && value == true) {}
                });
              },
              child: GestureDetector(
                onTap: () => onCancel.call(model.id),
                child: Container(
                  height: 35.w,
                  width: 35.w,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.21),
                      borderRadius: BorderRadius.all(Radius.circular(20.w))),
                  child: Image.asset(
                    ImageUtils.booking_cancel_icon,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
