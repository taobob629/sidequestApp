import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wy/widget/im/voice_record.dart';

import 'chat_voice_record_bar.dart';
import 'chat_voice_record_view.dart';

typedef SpeakViewChildBuilder = Widget Function(ChatVoiceRecordBar recordBar);

class ChatVoiceRecordLayout extends StatefulWidget {
  const ChatVoiceRecordLayout({
    Key? key,
    required this.builder,
    this.onCompleted,
  }) : super(key: key);

  final SpeakViewChildBuilder builder;
  final Function(int sec, String path)? onCompleted;

  @override
  _ChatVoiceRecordLayoutState createState() => _ChatVoiceRecordLayoutState();
}

class _ChatVoiceRecordLayoutState extends State<ChatVoiceRecordLayout> {
  var _selectedCancelArea = false;
  var _selectedPressArea = true;
  var _showVoiceRecordView = false;
  var _showSpeechRecognizing = false;
  var _showRecognizeFailed = false;
  Timer? _timer;
  late VoiceRecord _record;
  String? _path;
  int _sec = 0;

  @override
  void initState() {
    Get.put<CountDownController>(CountDownController(), permanent: true);
    super.initState();
  }

  /**
   * @isDeadLine 到达自动录制时间自动停止
   */
  void callback(int sec, String path, {bool isDeadLine = false}) async {
    _sec = sec;
    _path = path;
    if (isDeadLine) {
      //setState(() {
        stopRecord();
     // });
    }
  }

  @override
  void dispose() {
    if (null != _timer) {
      _timer?.cancel();
      _timer = null;
    }
    Get.delete<CountDownController>();
    super.dispose();
  }

  ChatVoiceRecordBar _createSpeakBar() => ChatVoiceRecordBar(
        onLongPressMoveUpdate: (details) {
          Offset global = details.globalPosition;
          setState(() {
          //  _selectedPressArea = global.dy >= 683.h;
          //   _selectedCancelArea = /*global.dy >= 563.h &&*/
          //       global.dy < 683.h && global.dx < 172.w;
            //  _selectedSoundToWordArea = global.dy < 683.h && global.dx >= 172.w;
          });
        },
        onLongPressEnd: (details) async {
          setState(() {
            stopRecord();
          });
        },
        onLongPressStart: (details) {
          setState(() {
            _record = VoiceRecord(callback, maxSeconds: 60,);
            _record.start();
            _selectedPressArea = true;
            _showVoiceRecordView = true;
          });
        },
      );

  stopRecord() async {
    await _record.stop();
    setState(() {
      if (_selectedPressArea) {
        _callback();
      }
      _showVoiceRecordView = false;
      _selectedPressArea = false;
      _selectedCancelArea = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _showVoiceRecordView,
          child: widget.builder(_createSpeakBar()),
        ),
        IgnorePointer(
          ignoring: !_showRecognizeFailed,
          child: Visibility(
            visible: _showVoiceRecordView,
            child: _buildRecordView(),
          ),
        ),
      ],
    );
  }

  _buildRecordView() {
    return ChatRecordVoiceView(
     // selectedCancelArea: _selectedCancelArea,
      selectedPressArea: _selectedPressArea,
      showSpeechRecognizing: _showSpeechRecognizing,
      showRecognizeFailed: _showRecognizeFailed,
      onCancel: () {
        setState(() {
          _selectedCancelArea = false;
          _selectedPressArea = true;
          _showVoiceRecordView = false;
          _showSpeechRecognizing = false;
          _showRecognizeFailed = false;
        });
      },
      onConfirm: () {
        setState(() {
          _callback();
          _selectedCancelArea = false;
          _selectedPressArea = true;
          _showVoiceRecordView = false;
          _showSpeechRecognizing = false;
          _showRecognizeFailed = false;
        });
      },
    );
  }

  var lastpath;

  void _callback() {
    if (lastpath == _path) {
      return;
    }
    if (_sec > 0 && null != _path) {
      lastpath = _path;
      widget.onCompleted?.call(_sec, _path!);
    }
  }
}
