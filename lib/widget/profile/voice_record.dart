import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../utils/permission_util.dart';

typedef RecordFc = Function(int sec, String path);

class VoiceRecord {
  static const _dir = "voice";
  static const _ext = ".m4a";
  late String _path;
  int _long = 0;
  late int _tag;
  RecordFc callback;
  Timer? timerTask;
  var maxSeconds; //最大秒数，可以发送的最大时长
  var minSeconds=3; //最小时长
  VoiceRecord(this.callback, {this.maxSeconds = 2 * 60})
      : _tag = DateTime.now().millisecondsSinceEpoch;

  start() async {
    startTimer();
    var path = (await getApplicationDocumentsDirectory()).path;
    _path = '$path/$_dir/$_tag$_ext';
    File file = File(_path);
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    //IHLog.d('start :$_path');
    _long = _now();
    PermissionUtil.microphone(() => Record.start(path: _path));
  }

  startTimer() {
    var start = 0;
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      start += 1;
      timerTask = timer;
      //  IHLog.d('start= $start');
      if (start > maxSeconds) {
        timer.cancel();
        stop();
      }
    });
  }

  stop() async {
  //  Get.find<CountDownController>().stopCountDown();
    timerTask?.cancel();
    _long = (_now() - _long) ~/ 1000;
    if (_long == 61 || _long == 59) _long = 60;
    bool isRecording = await Record.isRecording();
    if (isRecording) {
      await Record.stop();
      callback(_long, _path);
    }
  }

  int _now() => DateTime.now().millisecondsSinceEpoch;
}
