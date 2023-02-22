import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/dialog_input.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'package:wy/ui/profile/developer/developer_page.dart';

import 'profile_album_page.dart';
import 'profile_dashboard_page.dart';
import 'profile_posts_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final t = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile/profile_head_bg.webp"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 40),
                    child: Image.asset(
                      "assets/images/profile_setting.webp",
                      width: 26,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// nickname
                              Obx(() => Text(
                                    t.vm.value.nickName,
                                    style: TextStyle(fontSize: 19.sp, color: Colors.white, fontWeight: FontWeight.normal, height: 22.5 / 19),
                                  )),

                              /// labels: sex、language、location
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          margin: EdgeInsets.only(right: 10),
                                          height: 16.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                                                Color(0xFF1F84C9),
                                                Color(0xFF7CB9D5),
                                              ])),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/profile/icon_sex_${t.vm.value.gender - 1}.png",
                                                width: 8,
                                              ),
                                              Text(
                                                "${t.vm.value.age}",
                                                style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          margin: EdgeInsets.only(right: 10),
                                          height: 16.h,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff32353D)),
                                          child: Row(
                                            children: [
                                              Text(
                                                t.vm.value.language,
                                                style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          margin: EdgeInsets.only(right: 10),
                                          height: 16.h,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff32353D)),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/profile/icon_dibiao.webp",
                                                width: 8,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                t.vm.value.country.country,
                                                style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),

                              /// email
                              Obx(() => GestureDetector(
                                    onTap: t.goDev,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "ID:${t.vm.value.uk}",
                                              style: TextStyle(fontSize: 10.sp, color: Color(0xffC5C5C5), fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            t.vm.value.email,
                                            style: TextStyle(fontSize: 10.sp, color: Color(0xff54B3EF), fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Stack(alignment: AlignmentDirectional.center, clipBehavior: Clip.none, children: [
                          Obx(() => Container(
                                height: 64,
                                alignment: Alignment.bottomCenter,
                                child: ClipOval(
                                  child: ExtendedImage.network(
                                    t.vm.value.avatar,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                          Image.asset(
                            "assets/images/profile_avatar_border.webp",
                            width: 64,
                          ),
                          Obx(() => Visibility(
                                visible: t.vm.value.vipLevel < 5,
                                child: Positioned(
                                    bottom: -10,
                                    child: Image.asset(
                                      "assets/images/profile/icon_level_${t.vm.value.vipLevel == 0 ? 5 : t.vm.value.vipLevel}.webp",
                                      height: 28,
                                    )),
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            color: Color(0xff262731),
          ),

          /// Followers、Fans、Rating
          Obx(
            () => Container(
              height: 44,
              padding: const EdgeInsets.only(top: 5, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      "Followers: ${t.vm.value.followers}",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Fans: ${t.vm.value.fans}",
                    style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: t.vm.value.isAuth == 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Rating: ${t.vm.value.ranking}",
                        style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            color: Color(0xff262731),
          ),

          /// dashboard、post、album
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 30, right: 20),
            child: TabBar(
              controller: t.tabController,
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              indicatorColor: Color(0xFFFFCB0D),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.only(bottom: 5),
              labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "din"),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "din"),
              tabs: createTabs(),
            ),
          ),

          Expanded(child: TabBarView(controller: t.tabController, children: createPages()))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print(t.vm.value.countryModel);
      //   },
      // ),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Dashboard".tr,
    ));
    tabs.add(Text(
      "Posts".tr,
    ));
    tabs.add(Text(
      "Album".tr,
    ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: ProfileDashboardPage()));
    pages.add(KeepAliveWrapper(child: ProfilePostsPage()));
    pages.add(KeepAliveWrapper(child: ProfileAlbumPage()));
    return pages;
  }
}

class ProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  static ProfileController get find => Get.find();

  late TabController tabController;
  final vm = ProfileModel().obs;

  int devCount = 0;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    getProfileInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getProfileInfo() {
    ProfileApi.getProfileInfo().then((value) {
      vm.value = ProfileModel.fromJson(value);
    });
  }

  void goDev() {
    devCount++;
    if (devCount < 6) {
      return;
    }
    devCount = 0;

    Get.dialog(InputDialog(), barrierDismissible: true, barrierColor: Colors.black26).then((value) {
      if (value == "9637") {
        Get.to(() => DeveloperPage());
      } else {
        Get.back();
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
