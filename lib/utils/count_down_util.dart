import 'dart:async';

import 'package:get/get.dart';

class CountDownUtil {
  late Timer _timer;
  int _seconds = 60 * 15;
  var _countTime = "0";

  bool isShow = true;

  late Function(String countTime) callback;
  late Function completeCallback;

  CountDownUtil(Function(String countTime) callback, Function completeCallback,
      {int seconds = 60 * 15}) {
    this.callback = callback;
    this.completeCallback = completeCallback;
    this._seconds = seconds;
  }

  void updateSeconds(int seconds) {
    this._seconds = seconds;
  }

  void startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (v) {
      if (_seconds > 0) {
        _seconds--;
        _formatTime();
      } else {
        _timer.cancel();
        completeCallback();
      }
    });
  }

  void stopCountDown() {
    isShow = false;
    _timer.cancel();
    Get.back();
  }

  void _formatTime() {
    String formattedSeconds = _seconds.toString().padLeft(2, '0');
    _countTime = '${formattedSeconds}s';
    callback(_countTime);
  }
}
