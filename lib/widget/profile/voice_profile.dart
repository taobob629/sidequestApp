import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../controller/user_controller.dart';
import '../../service/voice_player.dart';
import '../../utils/toast_utils.dart';

class VoiceProfileWidget extends StatelessWidget {
  var pwId;
  var voice;
  Function()? toRecordPage;
  double maginBottom;
  double marginLeft;
  double? width;

  bool needEdit = true;

  VoiceProfileWidget(
      {@required this.pwId,
      @required this.voice,
      this.toRecordPage,
      this.width,
      this.needEdit = true,
      this.maginBottom = 12,
      this.marginLeft = 8}) {
    initPlayer();
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  set audioPlayer(AudioPlayer value) {
    _audioPlayer = value;
  }

  RxInt _playState = RxInt(PlayState.idle);

  int get playState => _playState.value;

  set playState(int value) {
    _playState.value = value;
  }

  Future<void> play() async {
    if (audioPlayer?.playing == true) {
      await audioPlayer?.stop();
      return;
    }
    if (voice.isEmpty) {
      showInfo(
        'No Voice'.tr,
      );
      return;
    }
    final duration =
        await audioPlayer?.setUrl(voice); // Schemes: (https: | file: | asset: )
    audioPlayer?.play();
  }

  void initPlayer() {
    audioPlayer = AudioPlayer();
    audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        playState = PlayState.playing;
      }
      switch (state.processingState) {
        case ProcessingState.idle:
          playState = PlayState.idle;
          break;
        case ProcessingState.loading:
          playState = PlayState.loadding;
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          playState = PlayState.idle;
          audioPlayer.stop();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: 30,
        margin: EdgeInsets.only(left: marginLeft, bottom: maginBottom),
        padding: EdgeInsets.only(left: 6.w, right: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                bottomLeft: Radius.circular(15.r)),
            gradient:
                LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
            boxShadow: [
              BoxShadow(
                  color: Color(0x29632BDA),
                  offset: Offset(0, 3.5),
                  blurRadius: 8,
                  spreadRadius: 0.5),
              BoxShadow(
                  color: Color(0x29FFFFFF),
                  offset: Offset(0, -1.5),
                  blurRadius: 10,
                  spreadRadius: 0.5),
            ]),
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
    switch (playState) {
      case PlayState.loadding:
        return Lottie.asset(
          'assets/anim/loadding.json',
          width: 158.w,
          height: 14.h,
          fit: BoxFit.contain,
        );
      case PlayState.playing:
        return InkWell(
          onTap: () => play(),
          child: Lottie.asset(
            'assets/anim/voice_record.json',
            // width: 158.w,
            height: 14.h,
            fit: BoxFit.contain,
          ),
        );
      case PlayState.idle:
      default:
        //判断是不是本人
        // if (voice.isEmpty) {
        //   if (pwId != loginUserID) {
        //     return Center(
        //       child: Text(
        //         'No Voice'.tr,
        //         style: TextStyle(fontSize: 12.sp),
        //       ),
        //     );
        //   }
        // }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => play(),
              child:
                  Image.asset(ImageUtils.icon_voice_play, height: 20),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () => play(),
              child: Image.asset(ImageUtils.icon_voice_progress,
                  height: 14),
            ),
            if (needEdit && pwId == loginUserID)
              GestureDetector(
                onTap: () => toRecordPage?.call(),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(ImageUtils.ic_edit, width: 14),
                ),
              )
          ],
        );
    }
  }
}
