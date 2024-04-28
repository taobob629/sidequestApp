import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/ext.dart';

import '../common/base_controller.dart';
import '../config/app_color.dart';
import '../config/icon_font.dart';

class TimerWidget extends StatelessWidget {
  int restSeconds;

  TimerWidget(this.restSeconds) {
    Get.put(TimerController(restSeconds));
  }

  @override
  Widget build(BuildContext context) {
    Gradient gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColor.accent,
          Colors.green,
          AppColor.yellow,
          AppColor.primary
        ]);
//根据gradient 创建shader
    var sections = ['day'.tr, 'hour'.tr, 'min'.tr, 'sec'.tr];
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, 1080, 1920));
    return Container(
      decoration: BoxDecoration(
        color: Color(0x77000000),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        // 阴影的颜色，模糊半径
        boxShadow: [BoxShadow(color: Color(0x55000000), blurRadius: 16)],
      ),
      constraints: BoxConstraints(minWidth: 120.w, maxWidth: 160.w),
      child: Column(
        children: [
          5.verticalSpace,
          Text(
            'COMMING SOON..',
            style: TextStyle(fontSize: 18.sp, fontFamily: FONT_BLACK),
          ),
          10.verticalSpace,
          Row(
            children: sections
                .map((e) => Expanded(
                        child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                    )))
                .toList(),
          ),
          3.verticalSpace,
          Row(
            children: [
              Obx(() => Expanded(
                      child: Text(
                    dealText(TimerController.find.day),
                    textAlign: TextAlign.center,
                    style: testStyle(),
                  ))),
              Text(
                ':',
                textAlign: TextAlign.center,
                style: testStyle(),
              ),
              Obx(() => Expanded(
                      child: Text(
                    dealText(TimerController.find.hour),
                    textAlign: TextAlign.center,
                    style: testStyle(),
                  ))),
              Text(
                ':',
                textAlign: TextAlign.center,
                style: testStyle(),
              ),
              Obx(() => Expanded(
                      child: Text(
                    dealText(TimerController.find.min),
                    textAlign: TextAlign.center,
                    style: testStyle(),
                  ))),
              Text(
                ':',
                textAlign: TextAlign.center,
                style: testStyle(),
              ),
              Obx(() => Expanded(
                      child: Text(
                    dealText(TimerController.find.sec),
                    textAlign: TextAlign.center,
                    style: testStyle(),
                  ))),
            ],
          ),
          5.verticalSpace,
        ],
      ),
    );
  }

  dealText(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  TextStyle testStyle() {
    return TextStyle(
      fontFamily: FONT_MEDIUM,
      fontSize: 16.sp,
      //  foreground: Paint()..shader = shader
    );
  }
}

const repeatPeriod = const Duration(seconds: 1);

class TimerController extends BasePageController {
  int restSeconds;
  var _resTime = ''.obs;
  var _day = 0.obs;

  get day => _day.value;

  set day(value) {
    _day.value = value;
  }

  var _hour = 0.obs;

  get hour => _hour.value;

  set hour(value) {
    _hour.value = value;
  }

  var _min = 0.obs;

  get min => _min.value;

  set min(value) {
    _min.value = value;
  }

  var _sec = 0.obs;

  get sec => _sec.value;

  set sec(value) {
    _sec.value = value;
  }

  get resTime => _resTime.value;

  set resTime(value) {
    _resTime.value = value;
  }

  TimerController(this.restSeconds);

  static TimerController get find => Get.find();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  Timer? _timer;

  updateTime() {
    var duration = Duration(seconds: restSeconds);
    // flog('Days: ${duration.inDaysRest}'); // 0
    // flog('Hours: ${duration.inHoursRest}'); // 0
    // flog('Minutes: ${duration.inMinutesRest}'); // 2
    // flog('Seconds: ${duration.inSecondsRest}'); // 3
    day = duration.inDaysRest;
    hour = duration.inHoursRest;
    min = duration.inMinutesRest;
    sec = duration.inSecondsRest;
    resTime =
        '距离抽奖:${duration.inDaysRest}${' day'.tr} ${duration.inHoursRest}${' hour'.tr} ${duration.inMinutesRest}${' min'.tr} ${duration.inSecondsRest}${' sec'.tr}';
    restSeconds = restSeconds - 1;
  }

  startTimer() {
    _timer = Timer.periodic(repeatPeriod, (timer) {
      //到时回调
      updateTime();
    });
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
  }
}
