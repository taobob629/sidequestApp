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
import 'package:wy/service/voice_player.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/im/voice_record.dart';

const int record_type_service = 1;
const int record_type_default = 0;

class RecordController extends BasePageController {
  int minSeconds = 3;
  int maxSeconds = 60;
  RxInt _countDownNum = RxInt(0);
  RxBool _isRecording = RxBool(false);

  bool get isRecording => _isRecording.value;

  set isRecording(bool value) {
    _isRecording.value = value;
  }

  int type = record_type_default;

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
    var params = Get.arguments as Map;
    recordFileUrl = params['voice'];
    type = params['type'] ?? 0;
    flog('recordFileUrl $recordFileUrl type:  $type');
    _record = VoiceRecord(
      (int sec, String path) {
        //onComplete(sec, path);
        flog('录制时长 $sec');
        if (sec < minSeconds) {
          err('The recording duration shall not be less than 3 seconds'.tr);
          stopRecord();
          return;
        }
        recordFileUrl = path;
      },
      maxSeconds: 60,
    );
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    AudioManager.instance.stop();
    timerTask?.cancel();
  }

  onComplete(var sec, var path) async {
    File file = File(path);
    if (await file.exists() == false) return;
    showLoadding();
    var url;
    if (type == record_type_service) {
      url= await Common.uploadServiceRecordFile(File(path), (count, total) {
        flog('(count / total ${count / total}');
      }, isVoiceFile: true)
          .catchError((e) {
        err('${e}');
        dismissLoadding();
      });
    }else {
      url = await Common.uploadFile(File(path), (count, total) {
        flog('(count / total ${count / total}');
      }, isVoiceFile: true);
    }
    dismissLoadding();
    toast('Upload success!'.tr);
    Get.back(result: url);
  }

  startRecord() {
    isRecording = true;
    startTimer();
    _record.start();
  }

  stopRecord() {
    isRecording = false;
    //countDownNum = 0;
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

  delete() {
    recordFileUrl = '';
    Get.back();
  }

  onOk() {
    if (recordFileUrl.isEmpty || recordFileUrl.startsWith('http')) {
      Get.back(result: recordFileUrl);
      return;
    }
    //文件要上传
    onComplete(null, recordFileUrl);
  }
}
