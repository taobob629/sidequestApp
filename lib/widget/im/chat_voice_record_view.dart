import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wy/utils/index.dart';

class CountDownController extends GetxController {
  RxInt surplusTimes = RxInt(-1); //剩余时长，开始倒计时的时间
  Timer? timerTask;

  /**
   * 开启倒计时
   */
  void startCountDown() {
    surplusTimes.value = 10;
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      timerTask = timer;
      surplusTimes.value = surplusTimes.value - 1;
      //  IHLog.d('surpluseTimes $surplusTimes');
      if (surplusTimes.value < 0) {
        //IHLog.d('倒计时十秒结束');
        timer.cancel();
      }
    });
  }

  stopCountDown() {
    surplusTimes.value = -1;
    timerTask?.cancel();
  }

  @override
  void dispose() {
    timerTask?.cancel();
    super.dispose();
  }
}

class ChatRecordVoiceView extends StatelessWidget {
  const ChatRecordVoiceView(
      {Key? key,
      //required this.selectedCancelArea,
      required this.selectedPressArea,
      required this.showSpeechRecognizing,
      required this.showRecognizeFailed,
      this.onCancel,
      this.onConfirm})
      : super(key: key);

 // final bool selectedCancelArea;
  final bool selectedPressArea;
  final bool showSpeechRecognizing;
  final bool showRecognizeFailed;
  final Function()? onCancel;
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    CountDownController controller = Get.find<CountDownController>();
    return Material(
      color: Color(0xFF000000).withOpacity(0.6),
      child: Stack(
        children: [
          Positioned(
            top: 360.h,
            left: 0,
            width: 375.w,
            child: _selectedPressAreaAnimationView(controller),
          ),
          // Positioned(
          //   top: 360.h,
          //   left: 29.w,
          //   child: _selectedCancelAreaAnimationView(),
          // ),
          // Positioned(
          //   top: 576.h,
          //   left: 35.w,
          //   child: _unselectedCancelAreaView(),
          // ),
          // Positioned(
          //   top: 563.h,
          //   left: 30.w,
          //   child: _selectedCancelAreaView(),
          // ),
          Positioned(
            top: 563.h,
            right: 30.w,
            child: _recognizingProgressView(),
          ),
          Positioned(
            top: 651.h,
            left: 0,
            width: 375.w,
            child: _selectedPressAreaReleaseText(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomBg(),
          ),
          Positioned(
            top: 719.h,
            left: 0,
            width: 375.w,
            child: _speakerIcon(),
          ),
          Positioned(
            top: 588.h,
            left: 54.w,
            child: _cancelSendView(),
          ),
          Positioned(
            top: 588.h,
            left: 0,
            child: _confirmSendView(),
          ),
        ],
      ),
    );
  }

  Widget _cancelSendView() => Visibility(
        visible: showSpeechRecognizing || showRecognizeFailed,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onCancel,
          child: Column(
            children: [
              ImageUtil.assetImage(
                'im/ic_voice_cancel',
                width: 18.w,
                height: 24.w,
              ),
              Text(
                '取消发送',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  Widget _confirmSendView() => Container(
        alignment: Alignment.center,
        width: 375.w,
        child: Visibility(
          visible: showSpeechRecognizing || showRecognizeFailed,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onConfirm,
            child: Column(
              children: [
                ImageUtil.assetImage(
                  'im/ic_voice_confirm',
                  width: 24.w,
                  height: 24.w,
                ),
                Text(
                  '确认发送',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _recognizingProgressView() => Visibility(
        visible: showSpeechRecognizing,
        child: Container(
          width: 102.w,
          height: 102.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFFFFF),
            ),
            child: Center(
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _bottomBg() => Visibility(
        visible: !showSpeechRecognizing && !showRecognizeFailed,
        child: ImageUtil.assetImage(
          (selectedPressArea) ? 'im/ic_voice_record_bg1' : 'im/ic_voice_record_bg2',
          width: 375.w,
          height: 125.h,
          fit: BoxFit.fill,
        ),
      );

  Widget _speakerIcon() => Visibility(
        visible: !showSpeechRecognizing && !showRecognizeFailed,
        child: Container(
          alignment: Alignment.center,
          child: ImageUtil.assetImage(
            'im/ic_voice_record_speaker',
            width: 36.w,
            height: 36.h,
          ),
        ),
      );

  Widget _selectedPressAreaReleaseText() => Visibility(
        visible: selectedPressArea,
        child: Text(
          '松开完成',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFBEBEBE),
            fontSize: 14.sp,
          ),
        ),
      );

  // Widget _selectedCancelAreaView() => Visibility(
  //       visible: selectedCancelArea,
  //       child: ImageUtil.assetImage(
  //         'im/ic_voice_record_cancel_white',
  //         width: 102.w,
  //         height: 102.h,
  //       ),
  //     );

  // Widget _selectedCancelAreaAnimationView() => Visibility(
  //       visible: selectedCancelArea,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             height: 95.h,
  //             width: 104.w,
  //             padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(6),
  //               color: Color(0xFFFA5251),
  //             ),
  //             child: Lottie.asset(
  //               'assets/anim/voice_record.json',
  //               width: 60.w,
  //               height: 25.h,
  //               fit: BoxFit.contain,
  //             ),
  //           ),
  //           ClipPath(
  //             child: Container(
  //               width: 10.w,
  //               height: 10.w,
  //               color: Color(0xFFFA5251),
  //             ),
  //             clipper: _ArrowClipper(),
  //           )
  //         ],
  //       ),
  //     );

  Widget _selectedPressAreaAnimationView(CountDownController controller) => Visibility(
        visible: selectedPressArea,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 194.w,
                height: 95.h,
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 27.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFFFFFFFF),
                ),
                child: Obx(() => controller.surplusTimes.value >= 0
                    ? Center(
                        child: Text(
                          '${controller.surplusTimes}"后将停止录音',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      )
                    : Lottie.asset(
                        'assets/anim/voice_record.json',
                        width: 140.w,
                        height: 35.h,
                        fit: BoxFit.contain,
                      )),
              ),
              ClipPath(
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  color: Color(0xFFFFFFFF),
                ),
                clipper: _ArrowClipper(),
              )
            ],
          ),
        ),
      );
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, -2);
    path.lineTo(size.width, -2);
    path.lineTo(size.width / 2, size.height * 2 / 4);

    // path.moveTo(0, size.height);
    // path.lineTo(size.width / 2, size.height / 2);
    // path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
