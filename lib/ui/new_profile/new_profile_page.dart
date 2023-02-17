import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/keep_alive_wrapper.dart';
import 'profile_album_page.dart';
import 'profile_dashboard_page.dart';
import 'profile_posts_page.dart';

class NewProfilePage extends StatelessWidget {
  NewProfilePage({Key? key}) : super(key: key);
  final controller = Get.put(NewProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                child: Image.asset("assets/images/profile_header_bg.webp", fit: BoxFit.fitWidth),
              ),
              Positioned(
                  top: Get.bottomBarHeight / 2,
                  right: 40,
                  child: Image.asset(
                    "assets/images/profile_setting.webp",
                  )),
              Positioned(
                  bottom: -50,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // CircleAvatar(
                      //   radius: 50,
                      //   backgroundColor: Colors.lightBlue,
                      // ).paddingOnly(top: 10),
                      Image.asset(
                        "assets/images/profile_avatar_border.webp",
                        width: 100,
                      ),
                      Positioned(
                          bottom: -15,
                          child: Image.asset(
                            "assets/images/ic_level20.webp",
                            width: 50,
                          )),
                    ],
                  )),
              Positioned(
                bottom: -10,
                left: 30,
                child: Text(
                  "ID:12345678",
                  style: TextStyle(fontSize: 10.sp, color: Color(0xffC5C5C5), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 70,
          ),

          /// nickname
          Text(
            "Anonuser",
            style: TextStyle(fontSize: 19.sp, color: Colors.white, fontWeight: FontWeight.normal, height: 22.5 / 19),
          ),

          /// email
          Text(
            "swiftlyfish@gmail.com",
            style: TextStyle(fontSize: 10.sp, color: Color(0xff54B3EF), fontWeight: FontWeight.normal),
          ),

          /// labels: sex、language、location
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 16.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                        Color(0xFF1F84C9),
                        Color(0xFF7CB9D5),
                      ])),
                  child: Row(
                    children: [
                      Text(
                        "♂ 26",
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
                        "English",
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
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        " London",
                        style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          /// Followers、Fans、Rating
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Followers: 0",
                  style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Fans: 0",
                  style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Rating: 0",
                  style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          ///
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TabBar(
              controller: controller.tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              // indicatorColor: Colors.white38,
              indicatorColor: Color(0xFFFFCB0D),
              indicatorSize: TabBarIndicatorSize.label,
              // indicator: HomeIndicator(),
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.only(bottom: 5),
              labelPadding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "din"),
              unselectedLabelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "din"),
              tabs: createTabs(),
            ),
          ),

          Expanded(child: TabBarView(controller: controller.tabController, children: createPages()))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(Get.statusBarHeight);
        },
      ),
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

class NewProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
