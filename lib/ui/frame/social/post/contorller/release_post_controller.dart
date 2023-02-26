import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/post_api.dart';

class ReleasePostController extends GetxController {
  TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final photoList = <String>[].obs;

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

  pickUploadPhoto() {
    _picker.pickImage(source: ImageSource.gallery).then((xfile) {
      if (xfile != null) {
        Common.uploadFile(File(xfile.path), (p0, p1) {
          EasyLoading.show();
        }).then((url) {
          EasyLoading.dismiss();
          if (url.isNotEmpty) {
            photoList.add(url);
          }
        }).whenComplete(() => EasyLoading.dismiss());
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
    });
  }

  delPhoto(String photoUrl) {
    photoList.remove(photoUrl);
  }

  submit() {
    if (textController.text.trim().isEmpty) {
      EasyLoading.showToast("Please enter content");
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
