import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/frame/profile/my_profile/my_profile_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/views.dart';

import '../model/album_item_model.dart';

class MyAlbumPage extends StatelessWidget {
  MyAlbumPage({Key? key}) : super(key: key);
  final t = Get.put(ProfileAlbumController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: 'Ablum'.tr,
        body: Obx(() {
          return t.list.isEmpty?buildLoad():SmartRefresher(
              controller: t.refreshController,
              onRefresh: () => t.onRefresh(),
              onLoading: () => t.loadMore(),
              enablePullUp: true,
              enableTwoLevel: true,
              header: t.list.length>1
                  ? SliverToBoxAdapter(
                child: item(0,height: 195.h,margin: EdgeInsets.only(top: 10.h,left: 15.w,right: 15.w)),
              )
                  : null,
              child: GridView.builder(
                padding: EdgeInsets.all(15),
                itemCount: t.list.length-1 ,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == t.list.length-2) {
                    return GestureDetector(
                      onTap: t.pickUploadPhoto,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.color7070),
                          borderRadius: BorderRadius.circular(11),
                          color: AppColor.color3033,
                        ),
                        child: Image.asset(
                          "assets/images/add_pic.png",
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    );
                  }
                  return item(index+1);
                },
              ));
        }));
  }

  Widget item(int index,{var height,EdgeInsets? margin}) {
    return GestureDetector(
                  onTap: () {
                    Get.to(() => PhotoViewPage(photoUrl: t.list[index].thumb));
                  },
                  onLongPress: () {
                    Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15), color: Color(0xFF262731)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  t.setBackground(t.list[index]);
                                },
                                child: Container(
                                  height: 52,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Set as background",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color(0xFF2D2E3A),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.back();
                              //   },
                              //   child: Container(
                              //     height: 52,
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       "Block",
                              //       style: TextStyle(fontSize: 16),
                              //     ),
                              //   ),
                              // ),
                              // Divider(
                              //   color: Color(0xFF2D2E3A),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  t.delPhoto(t.list[index]);
                                },
                                child: Container(
                                  height: 52,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                height: 10,
                                color: Color(0xFF2D2E3A),
                              ),
                              SafeArea(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 52,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 16, color: Color(0xFFFFD20E)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ignoreSafeArea: true);
                  },
                  child: Container(
                    height: height,
                    margin: margin,
                    decoration: BoxDecoration(
                      // border: Border.all(color: AppColor.color7070),
                      borderRadius: BorderRadius.circular(11),
                      color: AppColor.color3033,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ImageUtil.networkImage(
                          url: t.list[index].thumb,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                            right: 5,
                            bottom: 5,
                            child: GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Color(0xFF262731)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              t.setBackground(t.list[index]);
                                            },
                                            child: Container(
                                              height: 52,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Set as background picture",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color: Color(0xFF2D2E3A),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Container(
                                              height: 52,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Block Picture",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color: Color(0xFF2D2E3A),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              t.delPhoto(t.list[index]);
                                            },
                                            child: Container(
                                              height: 52,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Delete Picture",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            color: Color(0xFF2D2E3A),
                                          ),
                                          SafeArea(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                height: 52,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: 16, color: Color(0xFFFFD20E)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ignoreSafeArea: true);
                              },
                              child: Icon(Icons.more_horiz, color: Colors.white),
                              // child: Image.asset(
                              //   "assets/images/ic_edit_new.webp",
                              //   width: 20,
                              //   height: 20,
                              //   color: AppColor.yellow,
                              // ),
                            ))
                      ],
                    ),
                  ),
                );
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

class ProfileAlbumController extends GetxRefreshController<AlbumItemModel> {
  static ProfileAlbumController get find => Get.find();
  final ImagePicker _picker = ImagePicker();
  final list = <AlbumItemModel>[].obs;

  @override
  void onInit() {
    initialRefresh = true;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  pickUploadPhoto() {
    _picker.pickImage(source: ImageSource.gallery).then((xfile) {
      if (xfile != null) {
        Common.uploadFile(File(xfile.path), (p0, p1) {
          EasyLoading.show();
        }).then((val) {
          EasyLoading.dismiss();
          if (val.isNotEmpty) {
            ProfileApi.addPhoto(val).then((value) {
              onRefresh();
            });
          }
        }).whenComplete(() => EasyLoading.dismiss());
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
    });
  }

  // getPostList() {
  //   ProfileApi.getPhotoList().then((value) {
  //     list.value = value;
  //   });
  // }

  setBackground(AlbumItemModel model) {
    ProfileApi.setBackground(model.id).then((value) {
      // list.value = value;
      StorageManager.sharedPreferences.setString("ProfileBackground", model.thumb);
      ProfileController.find.background.value = model.thumb;
    });
  }

  delPhoto(AlbumItemModel model) {
    ProfileApi.delPhoto(model.id).then((value) {
      onRefresh();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<AlbumItemModel>> loadData({int pageNum = 0}) async {
    var result= await ProfileApi.getPhotoList(page: pageNum);
    result.insert(result.length, AlbumItemModel());
    return result;
  }
}
