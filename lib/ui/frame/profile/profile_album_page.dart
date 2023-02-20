import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/profile_api.dart';

import 'model/album_item_model.dart';

class ProfileAlbumPage extends StatelessWidget {
  ProfileAlbumPage({Key? key}) : super(key: key);
  final t = Get.put(ProfileAlbumController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => GridView.builder(
            padding: EdgeInsets.all(15),
            itemCount: t.list.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              childAspectRatio: 1.0,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == t.list.length) {
                return GestureDetector(
                  onTap: t.pickUploadPhoto,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: Color(0xff707070),
                    ),
                    child: Image.asset(
                      "assets/images/paly_add.png",
                      fit: BoxFit.fitWidth,
                      width: 60,
                      height: 60,
                    ),
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                clipBehavior: Clip.antiAlias,
                child: ExtendedImage.network(
                  t.list[index].thumb,
                  fit: BoxFit.fill,
                ),
              );
            },
          )),
    );
  }
}

class ProfileAlbumController extends GetxController with GetSingleTickerProviderStateMixin {
  static ProfileAlbumController get find => Get.find();
  final ImagePicker _picker = ImagePicker();
  final list = <AlbumItemModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getPostList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  pickUploadPhoto() {
    _picker.pickImage(source: ImageSource.gallery).then((xfile) {
      if (xfile != null) {
        Common.uploadFile(File(xfile.path), (p0, p1) {
          // EasyLoading.show();
          print(p0);
          print("p1");
          print(p1);
          EasyLoading.showProgress(p0 / p1);
        }).then((val) {
          EasyLoading.dismiss();
          if (val.isNotEmpty) {
            ProfileApi.addPhoto(val).then((value) {
              getPostList();
            });
          }
        });
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
    });
  }

  getPostList() {
    ProfileApi.getPhotoList().then((value) {
      list.value = value;
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
