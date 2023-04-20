import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/ui/common/dialog_show_info.dart';

class ReleasePostController extends GetxController {
  TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<String> photoList = [];
  final photoLocalFiles = <File>[].obs;

  final textLength = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  pickUploadPhoto() async {
    List<XFile>? files = await _picker.pickMultiImage(imageQuality: 30);
    if (files?.isEmpty == true) {
      return;
    }

    EasyLoading.show();
    int length = files?.length ?? 0;
    if (length > 9) {
      showInfoDialog('only 9 pictures allowed'.tr);
      length = 9;
    }

    photoLocalFiles.clear();
    photoList.clear();
    for (int i = 0; i < length; i++) {
      File file = File(files![i].path);
      photoLocalFiles.add(file);

      Common.uploadFile(file, (p0, p1) {}).then((url) {
        if (url.isNotEmpty) {
          photoList.add(url);
        }
      });
    }
    EasyLoading.dismiss();
  }

  delPhoto(File file) {
    photoList.remove(file.path);
    photoLocalFiles.remove(file);
  }

  submit() {
    if (textController.text.trim().isEmpty) {
      showInfoDialog('Please enter content'.tr);
      return;
    }
    EasyLoading.show();
    PostApi.releasePost(content: textController.text, images: jsonEncode(photoList)).then((value) {
      Get.back(result: "ReloadData");
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
    }).whenComplete(() => EasyLoading.dismiss());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
