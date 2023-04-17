import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wy/api/common.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/res/index.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wy/utils/index.dart';

class PlayState {
  static const int idle = 0;
  static const int playing = 1;
  static const int loadding = 2;
}

class VoiceWidget extends StatelessWidget {
  var pwId;
  var voice;
  Function()? toRecordPage;
  Function()? play;
  double maginBottom;
  double marginLeft;
  double width = 158;
  bool needEdit = true;

  VoiceWidget({@required this.pwId,
    @required this.voice,
    this.toRecordPage,
    this.play,
    this.width = 158,
    this.needEdit = true,
    this.maginBottom = 12,
    this.marginLeft = 20});

  AudioManager audioManager = AudioManager.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: width,
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
        return InkWell(
          onTap: () => play?.call(),
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
              onTap: () => play?.call(),
              child: ImageUtil.assetImage('profile/icon_voice_record', height: 14),
            ),
            GestureDetector(
              onTap: () => play?.call(),
              child: ImageUtil.assetImage('profile/icon_voice', height: 14),
            ),
            if (needEdit && pwId == loginUserID)
              GestureDetector(
                onTap: () => toRecordPage?.call(),
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

List voiceTypes = ['Record'.tr, 'From File'.tr];
const int MAX_RECORD_FILE_SIZE = 25;

pickVoiceDialog(BuildContext context, var voice, Function(String?) callback,{bool isServiceRecord=false}) {
  Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
            color: AppColor.itemBg,
            borderRadius:
            BorderRadius.only(topLeft: Radius
                .circular(16)
                .r, topRight: Radius
                .circular(16)
                .r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
              child: Text(
                'Select type'.tr,
                style: PageStyle.btnStyle,
              ),
            ),
            ...voiceTypes
                .mapIndexed(
                  (index, type) =>
                  ListTile(
                    onTap: () async {
                      switch (index) {
                        case 0:
                          Get.back();
                          var result = await Get.toNamed(AppPages.Record, arguments: voice);
                          return callback(result);
                        case 1:
                          FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
                            type: FileType.audio,
                          );
                          String? path = fileResult?.files?.single?.path;
                          if (path == null) return;
                          File file = File(path!);
                          var fileLength = file.lengthSync();
                          //文件大小限制
                          if (fileLength / 1000 / 1000 > MAX_RECORD_FILE_SIZE) {
                            EasyLoading.showError(
                                'Only files below ${MAX_RECORD_FILE_SIZE}M are supported!');
                            return;
                          }
                          //返回地址
                          if(isServiceRecord) {
                            var voiceUrl = await uploadFile(fileResult?.files?.single?.path);
                            return callback(voiceUrl);
                          }
                          var result = await Get.toNamed(AppPages.Record, arguments: fileResult?.files?.single?.path);
                          return callback(result);
                      }
                    } ,
                    leading: Text(
                      type,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            )
                .toList(),
            20.verticalSpace
          ],
        ),
      ),
      backgroundColor: AppColor.primary,
      enableDrag: false);
}

Future<String?> uploadFile(String? path) async {
  if (path == null) return null;
  File file = File(path);
  if (await file.exists() == false) return null;
  EasyLoading.show();
  var url = await Common.uploadServiceRecordFile(File(path), (count, total) {
    flog('(count / total ${count / total}');
  }, isVoiceFile: true)
      .catchError((e) {
    EasyLoading.showError('${e}');
    EasyLoading.dismiss();
  });
  flog('url $url');
  Get.back();
  EasyLoading.dismiss();
  EasyLoading.showToast('Upload success!'.tr);
  return url;
}
