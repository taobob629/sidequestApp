import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../api/profile_api.dart';
import '../../../../common/getx_refresh_controller.dart';
import '../../../../config/app_color.dart';
import '../../../../model/album_item_model.dart';
import '../../../../model/player_info_mdoel.dart';

class OtherAlbumPage extends StatelessWidget {
  OtherAlbumPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final t = Get.put(OtherAlbumController());

    return Obx(() {
      return SmartRefresher(
          controller: t.refreshController,
          onRefresh: () => t.onRefresh(),
          onLoading: () => t.loadMore(),
          enablePullUp: true,
          child: GridView.builder(
            padding: EdgeInsets.all(15),
            itemCount: t.list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              childAspectRatio: 1.0,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => PhotoViewPage(photoUrl: t.list[index].thumb));
                },
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: AppColor.color7070),
                    borderRadius: BorderRadius.circular(11),
                    color: AppColor.color3033,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: t.list[index].thumb,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              );
            },
          ));
    });
  }
}

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key, required this.photoUrl}) : super(key: key);
  final String photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: ExtendedImage.network(
            photoUrl,
            fit: BoxFit.fitWidth,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.5,
                animationMinScale: 0.5,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          ),
        ),
      ),
    );
  }
}

class OtherAlbumController extends GetxRefreshController<AlbumItemModel> {
  static OtherAlbumController get find => Get.find();
  // final ImagePicker _picker = ImagePicker();
  final list = <AlbumItemModel>[].obs;
  PlayerInfoModel player = PlayerInfoModel();

  @override
  void onInit() {
    initialRefresh = true;
    player = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // pickUploadPhoto() {
  //   _picker.pickImage(source: ImageSource.gallery).then((xfile) {
  //     if (xfile != null) {
  //       Common.uploadFile(File(xfile.path), (p0, p1) {
  //         showLoading();
  //       }).then((val) {
  //         dismissLoading();
  //         if (val.isNotEmpty) {
  //           ProfileApi.addPhoto(val).then((value) {
  //             onRefresh();
  //           });
  //         }
  //       }).whenComplete(() => dismissLoading());
  //     }
  //   }).onError((error, stackTrace) {
  //     dismissLoading();
  //   });
  // }

  // getPostList() {
  //   ProfileApi.getPhotoList().then((value) {
  //     list.value = value;
  //   });
  // }

  // setBackground(AlbumItemModel model) {
  //   ProfileApi.setBackground(model.id).then((value) {
  //     // list.value = value;
  //     StorageManager.sharedPreferences.setString("ProfileBackground", model.thumb);
  //     ProfileController.find.background.value = model.thumb;
  //   });
  // }

  // delPhoto(AlbumItemModel model) {
  //   ProfileApi.delPhoto(model.id).then((value) {
  //     onRefresh();
  //   });
  // }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<AlbumItemModel>> loadData({int pageNum = 0}) async {
    // TODO: implement loadData
    return await ProfileApi.getOtherPhotos(page: pageNum, uid: player.uid);
    throw UnimplementedError();
  }
}
