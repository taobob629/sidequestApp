import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../api/user_api.dart';
import '../../../../common/base_controller.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/player_info_mdoel.dart';
import '../../../../model/skill_model.dart';
import '../../../../service/voice_player.dart';
import '../../../../utils/toast_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/image_util.dart';
import '../../../../widget/profile/voice_profile.dart';
import '../../../../widget/profile/voice_widget.dart';
import '../../../../widget/route.dart';
import '../../main_page.dart';
import '../../playwith/balance/my_earnings_page.dart';
import '../../service/add/add_game_page.dart';
import '../../social/post/view/gift_animation.dart';
import '../play_order/play_order_page.dart';
import 'other_posts_page.dart';

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
    final String text = t.player.value.signature.isNotEmpty
        ? t.player.value.signature
        : "Thank you for your attention and love";
    final TextStyle textStyle = TextStyle(
      fontSize: 14.sp,
      color: Colors.white,
      fontFamily: FONT_LIGHT,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 5,
    );

    // 必须要有这个maxWidth，不然就会只能是一行
    textPainter.layout(maxWidth: Get.width - 40);

    final expandedHeight = textPainter.height + 270.h;

    return Scaffold(
      body: NestedScrollView(
          controller: t.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                title: Obx(() => Visibility(
                    visible: t.showTitle.value,
                    child: Text(
                      t.player.value.nickName,
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontFamily: FONT_LIGHT,
                      ),
                    ))),
                centerTitle: true,
                expandedHeight: expandedHeight,
                leading: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.back(),
                  child: Center(
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      margin: EdgeInsets.only(left: 16.w),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    // color: Colors.lightBlue,
                    child: Stack(
                      children: [
                        Container(
                          height: 230.h,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Obx(() => ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Colors.black.withOpacity(0.9)
                                        ],
                                        stops: [0.1, 1],
                                      ).createShader(bounds);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: t.player.value.backGround,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Positioned(
                                left: 16.w,
                                top: 90.h,
                                right: 0,
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Obx(() => ImageUtil.networkImage(
                                              url: t.player.value.avatar,
                                              fit: BoxFit.cover,
                                              width: 78.w,
                                              height: 78.w,
                                              border: 78.w,
                                            )),
                                        8.horizontalSpace,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                t.player.value.nickName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.sp,
                                                  fontFamily: FONT_MEDIUM,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              10.verticalSpace,
                                              Row(
                                                children: [
                                                  Text(
                                                    "ID:" + t.player.value.uk,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontSize: 12.sp,
                                                      fontFamily: FONT_LIGHT,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: t
                                                        .player
                                                        .value
                                                        .location
                                                        .country
                                                        .isNotEmpty,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth:
                                                                      120.w),
                                                          child: Text(
                                                            '   ${t.player.value.location.country}',
                                                            strutStyle: StrutStyle(
                                                                forceStrutHeight:
                                                                    true),
                                                            maxLines: 1,
                                                            softWrap: false,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.6),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  FONT_LIGHT,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 24.h,
                                      right: 0,
                                      height: 30.h,
                                      child: Obx(() => Visibility(
                                            visible:
                                                t.player.value.voice.isNotEmpty,
                                            child: VoiceProfileWidget(
                                              pwId: UserController
                                                  .find.userProfile.pwId,
                                              voice: t.player.value.voice,
                                              maginBottom: 0,
                                              marginLeft: 12.w,
                                              needEdit: t.isSelf,
                                              width: t.isSelf ? 98.w : 80.w,
                                              toRecordPage: () =>
                                                  t.toRecordPage(context),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 190.h,
                          left: 16.w,
                          right: 16.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTapDown: (details) {
                                  print(details.globalPosition);
                                  Offset offset = details.globalPosition;
                                  Get.dialog(Stack(
                                    alignment: AlignmentDirectional.topCenter,
                                    children: [
                                      Positioned(
                                        top: offset.dy -
                                            MediaQuery.of(Get.context!)
                                                .padding
                                                .top +
                                            15,
                                        left: offset.dx - 10,
                                        child: ClipPath(
                                          clipper: Triangle(dir: -1),
                                          child: Container(
                                            width: 20.0,
                                            height: 10.0,
                                            color: Color(0xff282640),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: offset.dy -
                                            MediaQuery.of(Get.context!)
                                                .padding
                                                .top +
                                            15 +
                                            10,
                                        child: Container(
                                          width: Get.width - 30.w,
                                          padding: EdgeInsets.all(10.r),
                                          decoration: BoxDecoration(
                                              color: Color(0xff282640),
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          child: Text(
                                            t.player.value.signature,
                                            style: TextStyle(
                                              color: Color(0xff8291B4),
                                              height: 1.2,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                                },
                                child: Text(
                                  text,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle,
                                ),
                              ),
                              20.verticalSpace,
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${t.player.value.followers}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      6.verticalSpace,
                                      Text(
                                        'Following',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12.sp,
                                          fontFamily: FONT_LIGHT,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  26.horizontalSpace,
                                  Column(
                                    children: [
                                      Text(
                                        "${t.player.value.fans}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      6.verticalSpace,
                                      Text(
                                        'Fans',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12.sp,
                                          fontFamily: FONT_LIGHT,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  26.horizontalSpace,
                                  // Column(
                                  //   children: [
                                  //     Text(
                                  //       "${t.player.value.}",
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 15.sp,
                                  //         fontFamily: FONT_MEDIUM,
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  //     ),
                                  //     6.verticalSpace,
                                  //     Text(
                                  //       'Likes & Col',
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //         color:
                                  //             Colors.white.withOpacity(0.6),
                                  //         fontSize: 12.sp,
                                  //         fontFamily: FONT_LIGHT,
                                  //         fontWeight: FontWeight.w400,
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  Spacer(),
                                  Obx(() => Visibility(
                                        visible:
                                            !t.isSelf && !t.player.value.follow,
                                        child: GestureDetector(
                                          onTapDown: (details) {
                                            t.followOrNot(
                                              context,
                                              details.globalPosition,
                                            );
                                          },
                                          child: Container(
                                            width: 76.w,
                                            height: 34.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: t.player.value.follow
                                                  ? null
                                                  : Border.all(
                                                      color: AppColor.yellow),
                                              gradient: t.player.value.follow
                                                  ? LinearGradient(
                                                      colors: AppColor
                                                          .yellowGradient)
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Text(
                                              "Follow".tr,
                                              style: TextStyle(
                                                color: AppColor.yellow,
                                                fontSize: 14.sp,
                                                fontFamily: FONT_MEDIUM,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  12.horizontalSpace,
                                  if (!t.isSelf)
                                    Image.asset(
                                      ImageUtils.profile_chat_icon,
                                      height: 34.h,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                    preferredSize: Size(double.infinity, 40.h),
                    child: Container(
                      width: 1.sw,
                      decoration: ShapeDecoration(
                        color: Color(0xFF141517),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
                          left: 30,
                          right: 20,
                        ),
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          controller: t.tabController,
                          isScrollable: true,
                          labelColor: Color(0xFFFFCB0D),
                          unselectedLabelColor: AppColor.textC5C5,
                          indicatorColor: Color(0xFFFFCB0D),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2,
                          indicatorPadding: EdgeInsets.only(bottom: 0),
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM,
                          ),
                          tabs: createTabs(),
                        ),
                      ),
                    )),
              ),
            ];
          },
          body: Column(
            children: [
              Container(
                height: 11.h,
                child: Stack(
                  children: [
                    Container(
                      color: Color(0xFF141517),
                      height: 11.h,
                    ),
                    Container(
                      color: hexColor('#303030'),
                      height: 1.h,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: t.tabController,
                  children: createPages(),
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Posts".tr,
    ));
    // tabs.add(Text(
    //   "Album".tr,
    // ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(OtherPostsPage());
    // pages.add(OtherAlbumPage());
    return pages;
  }
}

class OtherProfileController extends BasePageController {
  static OtherProfileController get find => Get.find();
  BuildContext? myContext;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioManager audioManager = AudioManager.instance;
  late TabController tabController;

  // final vm = ProfileModel().obs;
  final showTitle = false.obs;

  final player = PlayerInfoModel().obs;

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
    isSelf = UserController.find.userProfile.pwId == player.value.uid;

    scrollController.addListener(() {
      showTitle.value = scrollController.offset >= limitedHeight;
    });

    // bool? followKey = StorageManager.getBoolByKey('followKey');
    // if (followKey == null || followKey == false) {
    //   if (!isSelf && !player.value.follow) {
    //     ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
    //       (_) => ShowCaseWidget.of(myContext!).startShowCase([
    //         GlobalKeyConstants.followKey,
    //         GlobalKeyConstants.playKey,
    //       ]),
    //     );
    //   } else {
    //     ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
    //       (_) => ShowCaseWidget.of(myContext!).startShowCase([
    //         GlobalKeyConstants.playKey,
    //       ]),
    //     );
    //   }
    // }
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
    showLoading();
    UserApi.attention(player.value.memberId).then((value) async {
      dismissLoading();
      await showHearts(context, offset, "");
      player.value.follow = !player.value.follow;
      if (player.value.follow) {
        player.value.fans += 1;
      } else {
        player.value.fans -= 1;
      }
      player.refresh();
      UserController.find.updateInfo();
    }).catchError((e) {
      dismissLoading();
      print(e);
    });
  }

  editService(GamesItem game, ServiceItem serviceItem, String discount) async {
    if (isSelf) {
      // Get.toNamed(AppPages.ServiceAndOrders);
      List<SkillModel> list = await UserApi.myauthlist();
      Iterable<SkillModel> skillModel =
          list.where((element) => element.id == game.id);
      jumpPage(AddGamePage(skillModel.first.toJson()), callback: (res) {
        flog('Get.ard ${Get.arguments}');
      });
    } else {
      var uk = await Get.to(() {
        return MulitablePlayOrderPage(
          serviceItemList: [serviceItem],
          discount: discount,
        );
      });
      // flog('$res', 'Get.to(()=>PlayOrder');
      if (uk != null) {
        if (uk == 0) {
          Get.back();
          MainPageController.find.currentIndex.value = 3;
          MainPageController.find.controller.jumpToPage(3);
        }
      }
    }
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

  String getDiscount(List<ServiceItem> serviceItem) {
    String discount = '';
    for (int i = 0; i < serviceItem.length; i++) {
      if (serviceItem[i].discount != '' &&
          jsonDecode(serviceItem[i].discount)['enable'] == 1) {
        discount = serviceItem[i].discount;
        break;
      }
    }

    if (discount.contains('type')) {
      dynamic result = jsonDecode(discount);
      int type = result['type'];
      if (type == 1) {
        return 'Discount ${result['discount']}% OFF';
      } else if (type == 2) {
        return 'Buy ${result['buy']} Get ${result['get']}';
      } else if (type == 3) {
        return '1st Order Free ${result['discount']}% OFF';
      }
    }

    return discount;
  }

  String getItemDiscount(String discount) {
    if (discount.isEmpty) {
      return discount;
    }
    dynamic result = jsonDecode(discount);
    int type = result['type'];
    if (type == 1) {
      return 'Discount ${result['discount']}% OFF';
    } else if (type == 2) {
      return 'Buy ${result['buy']} Get ${result['get']}';
    } else if (type == 3) {
      return '1st Order Free ${result['discount']}% OFF';
    }
    return discount;
  }

// stop() async {
//   playState=PlayState.idle;
//   if(audioPlayer?.playing == true)
//   await audioPlayer?.stop();
// }
}
