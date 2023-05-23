import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/ui/common/dialog_show_info.dart';
import 'package:wy/ui/im/im_util.dart';

import '../../../../../api/common.dart';
import '../../../../../utils/toast_utils.dart';

const int TYPE_INVITE = 1;
const int TYPE_DEFAULT = 0;

class ReleasePostController extends GetxController {
  TextEditingController textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final photoList = <String>[].obs;

  final textLength = 0.obs;
  RxInt _type = RxInt(TYPE_DEFAULT);

  int get type => _type.value;

  set type(int value) {
    _type.value = value;
  } //0是图文 1是建群邀请

  var gid;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var arg = Get.arguments as Map;
      type = arg['type'] ?? TYPE_DEFAULT;
      gid = arg['gid'];
      if (gid != null) {
        var group_name = arg['group_name'];
        textController.text = 'Welcome to our new group" $group_name"! Join us and let\'s have fun together!';
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  pickUploadPhoto() async {
    print('photoList = ${photoList.length}');
    List<XFile> files = await _picker.pickMultiImage();
    if (files.isEmpty == true) {
      return;
    }

    if (files.length > 9 || (photoList.length + files.length) > 9) {
      showInfoDialog('only 9 pictures allowed'.tr);
      return;
    }

    showLoading();
    List<File> compressList = await compressImages(files, 5 * 1024 * 1024);
    for (int i = 0; i < compressList.length; i++) {
      Common.uploadFile(compressList[i], (p0, p1) {}).then((url) {
        if (url.isNotEmpty) {
          photoList.add(url);
        }
        if (i == compressList.length - 1) {
          dismissLoading();
        }
      });
    }
  }

  Future<List<File>> compressImages(List<XFile> images, int maxSize) async {
    List<File> compressedImages = [];

    for (final imageFile in images) {
      File file = File(imageFile.path);

      final String filePath = imageFile.path;

      final int originalFileSize = File(filePath).lengthSync();

      if (originalFileSize > maxSize) {
        final String fileName = path.basename(filePath);
        final String compressedFileName =
            '${path.withoutExtension(fileName)}_compressed.jpg';
        final String compressedFilePath =
            path.join(path.dirname(filePath), compressedFileName);

        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath,
          compressedFilePath,
          quality: 50,
        );

        if (compressedImage != null) {
          compressedImages.add(compressedImage);
        }
      } else {
        compressedImages.add(file);
      }
    }

    return compressedImages;
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
            content: type == TYPE_INVITE
                ? buildShareGroupText(content, gid)
                : content,
            images:
                type == TYPE_INVITE ? jsonEncode([gid]) : jsonEncode(photoList),
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
