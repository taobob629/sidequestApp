import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/index.dart';

class PlayState {
  static const int idle = 0;
  static const int playing = 1;
  static const int loadding = 2;
}
class VoiceWidget extends StatelessWidget{
  var pwId;
  var voice;
  Function()? toRecordPage;
  Function()? play;
  double maginBottom;
  double marginLeft;
  VoiceWidget({@required this.pwId, @required this.voice,this.toRecordPage,this.play,this.maginBottom=12,this.marginLeft=20});
  AudioManager audioManager=AudioManager.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 158,
        height: 26,
        margin: EdgeInsets.only(left: marginLeft, bottom: maginBottom),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 0.5, offset: Offset(0, 3.5))]),
        child: Obx(() => playWidget()),
      ),
      onTap: () {
        // controller.play();
      },
    );
  }

  UserController userController = UserController.find;
  playWidget() {
    var loginUserID = userController.userProfile?.pwId;
    switch (audioManager.playState) {
      case PlayState.loadding:
        return Lottie.asset(
          'assets/anim/loadding.json',
          width: 158.w,
          height: 14.h,
          fit: BoxFit.contain,
        );
      case PlayState.playing:
        return Lottie.asset(
          'assets/anim/voice_record.json',
          // width: 158.w,
          height: 14.h,
          fit: BoxFit.contain,
        );
      case PlayState.idle:
      default:
      //判断是不是本人
        if (voice.isEmpty) {
          if (pwId != loginUserID) {
            return Center(
              child: Text(
                'No Voice'.tr,
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () =>play?.call(),
              child: ImageUtil.assetImage('profile/icon_voice_record', height: 14),
            ),
            GestureDetector(
              onTap: () =>play?.call(),
              child: ImageUtil.assetImage('profile/icon_voice', height: 14),
            ),
            if ( pwId==loginUserID)
              GestureDetector(
                onTap: () =>toRecordPage?.call(),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: ImageUtil.assetImage('ic_edit', width: 14),
                ),
              )
          ],
        );
    }
  }

}
