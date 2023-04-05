/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:wy/api/common.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/im/voice_record.dart';

class RecordController extends BasePageController {
  int maxSeconds = 60;
  RxInt _countDownNum = RxInt(0);

  int get countDownNum => _countDownNum.value;

  set countDownNum(int value) {
    _countDownNum.value = value;
  }

  countDownShow() {
    if (countDownNum == 0) return '00:00';
    if (countDownNum < 60) {
      return countDownNum < 10 ? '00:0$countDownNum' : '00:$countDownNum';
    }
  }

  RxString _recordFileUrl = RxString('');

  String get recordFileUrl => _recordFileUrl.value;

  set recordFileUrl(String value) {
    _recordFileUrl.value = value;
  }

  late VoiceRecord _record;

  @override
  void onInit() {
    _record = VoiceRecord(
      (int sec, String path) {
        flog('record Complete---$path');
        recordFileUrl = path;
        onComplete(sec,path);
      },
      maxSeconds: 60,
    );
    recordFileUrl = Get.arguments ?? '';
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    timerTask?.cancel();
  }

  onComplete(var sec, var path) async {
    File file = File(path);
    if (await file.exists() == false) return;
    showLoadding();
    var url = await Common.uploadFile(File(path), (count, total) {
      //progress(count / total);
      flog('(count / total ${count / total}');
    }, isVoiceFile: true);
    dismissLoadding();
    toast('Upload success!'.tr);
    Get.back(result: url);
  }

  startRecord() {
    startTimer();
    _record.start();
  }

  stopRecord() {
    countDownNum = 0;
    _record.stop();
    timerTask?.cancel();
  }

  Timer? timerTask;

  startTimer() {
    countDownNum = 0;
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      timerTask = timer;
      countDownNum += 1;
    });
  }

  delete() {}
}
