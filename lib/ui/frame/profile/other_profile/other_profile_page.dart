import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';
import 'package:wy/ui/frame/social/post/view/gift_animation.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_widget.dart';

import '../../../../model/pay_info_model.dart';
import '../../../../model/skill_model.dart';
import '../../../../widget/route.dart';
import '../../../service/add/add_game_page.dart';
import '../../messages/chat/chat_page.dart';
import '../play_order/play_order_page.dart';
import 'other_album_page.dart';
import 'other_dashboard_page.dart';
import 'other_posts_page.dart';
import 'package:just_audio/just_audio.dart';

class PlayState {
  static const int idle = 0;
  static const int playing = 1;
  static const int loadding = 2;
}

class OtherProfilePage extends StatelessWidget {
  OtherProfilePage({Key? key}) : super(key: key);
  final t = Get.put(OtherProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          NestedScrollView(
              controller: t.scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    title: Obx(() => Visibility(
                        visible: t.showTitle.value,
                        child: Text(
                          t.player.value.nickName,
                          style: TextStyle(fontSize: 19.sp, fontFamily: FONT_LIGHT),
                        ))),
                    centerTitle: true,
                    expandedHeight: 358 - Get.mediaQuery.padding.top,
                    toolbarHeight: 44,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        // color: Colors.lightBlue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                // height: 208,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Obx(() => ImageUtil.networkImage(
                                          url: t.player.value.backGround,
                                          fit: BoxFit.cover,
                                        )),
                                    Opacity(
                                      opacity: 0.9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Color(0x00131010), Color(0xFF1B1A1E)],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20, bottom: 15.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
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
                                                        Obx(() => Container(
                                                              height: 30.h,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 30.h,
                                                                    child: Text(
                                                                      t.player.value.nickName,
                                                                      style: TextStyle(fontSize: 19.sp, fontFamily: FONT_LIGHT),
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: !t.isSelf,
                                                                    child: GestureDetector(
                                                                      onTapDown: (details) {
                                                                        t.followOrNot(context, details.globalPosition);
                                                                      },
                                                                      child: Container(
                                                                        height: 30,
                                                                        padding: const EdgeInsets.only(left: 10),
                                                                        child: Image.asset(
                                                                          t.player.value.follow ? "assets/images/profile/followed.webp" : "assets/images/profile/follow.webp",
                                                                          width: 20,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
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
                                                                        if (t.player.value.sex != 2)
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 3),
                                                                            child: Image.asset(
                                                                              "assets/images/profile/icon_sex_${t.player.value.sex}.png",
                                                                              width: 8,
                                                                            ),
                                                                          ),
                                                                        Text(
                                                                          "${t.player.value.age}",
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
                                                                          t.player.value.language,
                                                                          style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: t.player.value.location.country.isNotEmpty,
                                                                    child: Container(
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
                                                                            t.player.value.location.country,
                                                                            style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (!t.isSelf) {
                                                      UserController.find.jumpChat(t.player.value.uk);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 25),
                                                    child: Stack(alignment: AlignmentDirectional.center, clipBehavior: Clip.none, children: [
                                                      Obx(() => Container(
                                                            height: 64,
                                                            alignment: Alignment.bottomCenter,
                                                            child: ClipOval(
                                                              child: ImageUtil.networkImage(
                                                                url: t.player.value.avatar,
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
                                                      // Obx(() => Visibility(
                                                      //       visible: userController.userProfile.value.vipLevel >= 5 && userController.userProfile.value.isAuth == 1,
                                                      //       child: Positioned(
                                                      //           bottom: -10,
                                                      //           child: Image.asset(
                                                      //             "assets/images/profile/icon_level_${userController.userProfile.value.vipLevel == 0 ? 5 : userController.userProfile.value.vipLevel}.webp",
                                                      //             height: 28,
                                                      //           )),
                                                      //     )),
                                                    ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            VoiceWidget(pwId: t.player.value?.uid, play: () => t.audioManager.play(t.player.value.voice), voice: t.player.value.voice, toRecordPage: () => t.toRecordPage(context)),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              height: 28,
                              alignment: Alignment.topLeft,
                              child: Text(
                                t.player.value.signature.isNotEmpty ? t.player.value.signature : "Thank you for your attention and love",
                                style: TextStyle(fontSize: 12.sp, color: Color(0xFF808388), fontFamily: FONT_LIGHT),
                              ),
                            ),
                            Column(
                              children: [
                                Obx(
                                  () => Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: BorderSide(color: AppColor.itemBg, width: 1),
                                      bottom: BorderSide(color: AppColor.itemBg, width: 1),
                                    )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Followers".tr + ": ${t.player.value.followers}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                        ),
                                        Text(
                                          "Fans".tr + ": ${t.player.value.fans}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                        ),
                                        Visibility(
                                          child: Text(
                                            "Rating".tr + ": ${t.player.value.ranking}",
                                            style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                          ),
                                        ),
                                        Text(
                                          "Services".tr + ": ${t.player.value.age}",
                                          style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: FONT_LIGHT),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                        preferredSize: Size(double.infinity, 40),
                        child: Container(
                          // color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, left: 30, right: 20),
                            child: TabBar(
                              controller: t.tabController,
                              isScrollable: false,
                              labelColor: Colors.white,
                              unselectedLabelColor: AppColor.textC5C5,
                              indicatorColor: Color(0xFFFFCB0D),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 2,
                              indicatorPadding: EdgeInsets.only(bottom: 5),
                              labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                              labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM),
                              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM),
                              tabs: createTabs(),
                            ),
                          ),
                        )),
                  ),
                ];
              },
              body: TabBarView(controller: t.tabController, children: createPages())),
          if (!t.isSelf)
            Positioned(
                bottom: Get.mediaQuery.padding.bottom + 20,
                child: GestureDetector(
                  onTap: () {
                    t.jumpChat(t.player.value.uk);
                  },
                  child: Visibility(
                    child: Container(
                      width: 240,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: AppColor.yellowGradient),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Image.asset(
                              "assets/images/profile/icon_pinlun.webp",
                              width: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Messages".tr,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    if (t.player.value.isAuth)
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
    if (t.player.value.isAuth) pages.add(OtherDashboardPage());
    pages.add(OtherPostsPage());
    pages.add(OtherAlbumPage());
    return pages;
  }
}

class OtherProfileController extends BasePageController with GetSingleTickerProviderStateMixin {
  static OtherProfileController get find => Get.find();
  AudioPlayer audioPlayer = AudioPlayer();
  AudioManager audioManager = AudioManager.instance;
  late TabController tabController;

  // final vm = ProfileModel().obs;
  final showTitle = false.obs;

  final player = PlayerInfoModel().obs;

  final selGame = GamesItem().obs;

  ScrollController scrollController = ScrollController();

  double limitedHeight = 88 + Get.mediaQuery.padding.top;

  bool isSelf = false;

  @override
  void onInit() {
    // initPlayer();
    player.value = Get.arguments;

    if (player.value.isAuth) {
      tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    } else {
      tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    }
    isSelf = UserController.find.userProfile?.pwId == player.value.uid;

    scrollController.addListener(() {
      showTitle.value = scrollController.offset >= limitedHeight;
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // getProfileInfo();
  }

  // getProfileInfo() {
  //   ProfileApi.getPlayerInfo(playerId: player.value.uid).then((value) {
  //     player.value = value..uid = player.value.uid;
  //   });
  // }

  followOrNot(context, offset) {
    if (isSelf) {
      return;
    }
    UserApi.attention(player.value.uid).then((value) {
      player.value.follow = !player.value.follow;
      if (player.value.follow) {
        player.value.fans += 1;
        showHearts(context, offset, "");
      } else {
        player.value.fans -= 1;
      }
      player.refresh();
    }).catchError((e) {
      print(e);
    });
  }

  editService(GamesItem game, ServiceItem serviceItem) async {
    if (isSelf) {
      // Get.toNamed(AppPages.ServiceAndOrders);
      List<SkillModel> list = await UserApi.myauthlist();
      Iterable<SkillModel> skillModel = list.where((element) => element.id == player.value.games[0].id);
      jumpPage(AddGamePage(skillModel.first.toJson()), callback: (res) {
        flog('Get.ard ${Get.arguments}');
      });
    } else {
      var uk = await Get.to(() {
        return MulitablePlayOrderPage(
          serviceItemList: [serviceItem],
        );
      });
      // flog('$res', 'Get.to(()=>PlayOrder');
      if (uk != null) {
        if (uk == 0) {
          Get.back();
          MainPageController.find.currentIndex.value = 3;
          MainPageController.find.controller.jumpToPage(3);
        } else {
          jumpChat(uk);
        }
      }
    }
  }

  jumpChat(uk) {
    UserController.find.jumpChat(uk);
  }

  @override
  void onClose() {
    super.onClose();
    AudioManager.instance.stop();
    // stop();
  }

  // void initPlayer() {
  //   audioPlayer.playerStateStream.listen((state) {
  //     flog('playerStateStream $state');
  //     if (state.playing) {
  //       playState = PlayState.playing;
  //     }
  //     switch (state.processingState) {
  //       case ProcessingState.idle:
  //         playState = PlayState.idle;
  //         break;
  //       case ProcessingState.loading:
  //         playState = PlayState.loadding;
  //         break;
  //       case ProcessingState.buffering:
  //         break;
  //       case ProcessingState.ready:
  //         break;
  //       case ProcessingState.completed:
  //         stop();
  //         break;
  //     }
  //   });
  // }

  // RxInt _playState = RxInt(PlayState.idle);
  //
  // int get playState => _playState.value;
  //
  // set playState(int value) {
  //   _playState.value = value;
  // }

  // Future<void> play() async {
  //   if (audioPlayer?.playing == true) {
  //     await audioPlayer.stop();
  //     return;
  //   }
  //   var url = OtherProfileController.find.player.value.voice;
  //   if (url.isEmpty) err('No Voice'.tr);
  //   final duration = await audioPlayer?.setUrl(url); // Schemes: (https: | file: | asset: )
  //   audioPlayer.play();
  // }
  toRecordPage(BuildContext context) {
    pickVoiceDialog(context, player.value.voice, (result) {
      flog('callback $result');
      if (result != null) player.value.voice = result;
    });
    // Get.toNamed(AppPages.Record,arguments: player.value.voice)?.then((result) {
    //   if (result != null) player.value.voice = result;
    // });
  }

  // stop() async {
  //   playState=PlayState.idle;
  //   if(audioPlayer?.playing == true)
  //   await audioPlayer?.stop();
  // }
}
