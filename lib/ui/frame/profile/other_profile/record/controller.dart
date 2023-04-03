/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/common.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/ui/frame/profile/other_profile/other_profile_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/im/chat_voice_record_view.dart';

class RecordController extends BasePageController {
  @override
  void onInit() {
    super.onInit();
    Get.put(CountDownController());
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<CountDownController>();
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
}
