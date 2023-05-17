import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/ui/common/dialog_show_info.dart';
import 'package:wy/ui/im/im_util.dart';
import 'package:wy/utils/utils.dart';

import '../../../../../utils/toast_utils.dart';

const int TYPE_INVITE = 1;
const int TYPE_DEFAULT = 0;

class ReleasePostController extends GetxController {
  TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final photoList = <String>[].obs;

  final textLength = 0.obs;
  var type = TYPE_DEFAULT; //0是图文 1是建群邀请
  var gid;

  @override
  void onInit() {
    super.onInit();
    var arg = Get.arguments as Map;
    type = arg['type'] ?? TYPE_DEFAULT;
    gid = arg['gid'];
    if (gid != null) {
      var group_name = arg['group_name'];
      textController.text = '我刚创建了一个 " $group_name " 交流群，大家快来加入吧!';
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  pickUploadPhoto() async {
    print('photoList = ${photoList.length}');
    List<XFile>? files = await _picker.pickMultiImage();
    if (files == null || files?.isEmpty == true) {
      return;
    }

    if (files.length > 9 || (photoList.length + files.length) > 9) {
      showInfoDialog('only 9 pictures allowed'.tr);
      return;
    }

    showLoading();
    for (int i = 0; i < files.length; i++) {
      File file = File(files[i].path);
      // 最大5M
      if (file.lengthSync() > 2 * 1024 * 1024) {
        dismissLoading();
        showInfoDialog('The maximum size of the photo is 5MB'.tr);
        return;
      }

      Common.uploadFile(file, (p0, p1) {}).then((url) {
        if (url.isNotEmpty) {
          photoList.add(url);
          dismissLoading();
        }
      });
    }
  }

  delPhoto(String photoUrl) {
    photoList.remove(photoUrl);
  }

  submit() {
    if (textController.text.trim().isEmpty) {
      showInfoDialog('Please enter content'.tr);
      return;
    }
    showLoading();
    var content = textController.text;

    PostApi.releasePost(
            content: type == TYPE_INVITE ? buildShareGroupText(content, gid) : content,
            images:type == TYPE_INVITE ?jsonEncode([gid]): jsonEncode(photoList),
            type: type)
        .then((value) {
      Get.back(result: "ReloadData");
    }).onError((error, stackTrace) {
      dismissLoading();
    }).whenComplete(() => dismissLoading());
  }

  @override
  void onClose() {
    super.onClose();
  }
}
