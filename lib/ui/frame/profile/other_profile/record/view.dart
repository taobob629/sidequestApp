/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/app.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/im/chat_voice_record_bar.dart';
import 'package:wy/widget/im/chat_voice_record_layout.dart';

import 'controller.dart';

class RecordViewPage extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return ChatVoiceRecordLayout(
      builder: (ChatVoiceRecordBar recordBar) => Scaffold(
        appBar: AppBar(
          title: Text('Voice Record'.tr),
        ),
        body: Container(
          child: recordBar,
        ),
        //  bottomNavigationBar: ,
      ),
      onCompleted: (sec, path) {
        flog('onComplete---$path $sec');
        controller.onComplete(sec, path);
      },
    );
  }
}
