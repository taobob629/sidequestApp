import 'dart:async';

class CountDownUtil {
  late Timer timer;
  int seconds = 60 * 15;
  var countTime = "0";

  late Function(String countTime) callback;
  late Function completeCallback;

  CountDownUtil(Function(String countTime) callback, Function completeCallback,
      {int seconds = 60 * 15}) {
    this.callback = callback;
    this.completeCallback = completeCallback;
    this.seconds = seconds;
  }

  void startCountDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (v) {
      if (seconds > 0) {
        seconds--;
        _formatTime();
      } else {
        timer.cancel();
        completeCallback();
      }
    });
  }

  void stopCountDown() {
    timer.cancel();
  }

  void _formatTime() {
    String formattedSeconds = seconds.toString().padLeft(2, '0');
    countTime = '${formattedSeconds}s';
    callback(countTime);
  }
}
