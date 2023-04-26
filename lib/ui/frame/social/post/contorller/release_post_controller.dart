import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/ui/common/dialog_show_info.dart';

class ReleasePostController extends GetxController {
  TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final photoList = <String>[].obs;

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
    print('photoList = ${photoList.length}');
    List<XFile>? files = await _picker.pickMultiImage();
    if (files==null||files?.isEmpty == true) {
      return;
    }

    if (files.length > 9 || (photoList.length + files.length) > 9) {
      showInfoDialog('only 9 pictures allowed'.tr);
      return;
    }

    EasyLoading.show();
    for (int i = 0; i < files.length; i++) {
      File file = File(files[i].path);
      // 最大5M
      if (file.lengthSync() > 2 * 1024 * 1024) {
        EasyLoading.dismiss();
        showInfoDialog('The maximum size of the photo is 5MB'.tr);
        return;
      }

      Common.uploadFile(file, (p0, p1) {}).then((url) {
        if (url.isNotEmpty) {
          photoList.add(url);
          EasyLoading.dismiss();
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
    EasyLoading.show();
    PostApi.releasePost(
            content: textController.text, images: jsonEncode(photoList))
        .then((value) {
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
