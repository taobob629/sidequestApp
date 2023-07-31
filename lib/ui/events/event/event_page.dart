import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/events_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/event_detail_model.dart';
import 'package:wy/model/selector_item.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/events/event/event_selecto_widget.dart';
import 'package:wy/ui/events/event/team_page.dart';
import 'package:wy/ui/events/widget/confirm_fee_dialog.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/time_utils.dart';
import 'package:wy/widget/views.dart';

import '../../../utils/toast_utils.dart';
import '../widget/event_header.dart';
import 'join_button.dart';
import 'tab_overview_page.dart';
import 'tab_participants_page.dart';
import 'tab_prize_page.dart';
import 'tab_rules_page.dart';

class EventPage extends StatelessWidget {
  late final EventPageController controller;

  late final int id;
  late final bool joined;

  EventPage({required int id, required int type, bool joined = false}) {
    this.id = id;
    this.joined = joined;
    controller = Get.put(EventPageController(id: id, type: type));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() => controller.eventDetailModel.value.id == 0
          ? buildLoad()
          : NestedScrollView(
              controller: controller.scrollController,
              headerSliverBuilder: (context, bool) {
                return [
                  Obx(() {
                    return SliverAppBar(
                        elevation: 0,
                        pinned: true,
                        title: PageTitle(
                          title: controller.title.value,
                          color: controller.titleColor.value,
                        ),
                        backgroundColor: AppColor.background,
                        expandedHeight: controller.headerHeight.value,
                        flexibleSpace: controller.eventDetailModel.value.image.isEmpty
                            ? null
                            : EventFlexibleHeader(
                                image: controller.eventDetailModel.value.image,
                              ));
                  }),
                  SliverPersistentHeader(
                      pinned: true, delegate: _StickyTabBarDelegate(child: _buildTabBar())),
                ];
              },
              body: Container(
                padding: const EdgeInsets.only(top: 1),
                child: TabBarView(controller: controller.tabController, children: createPages()),
              ),
            )),
      floatingActionButton: Obx(() => controller.eventDetailModel.value.id == 0
          ? Container()
          : Container(
              width: Get.width-30,
              //  height: 150,
              constraints: BoxConstraints(maxHeight: 150.h),
              child:  Obx(() => _buildBtn(context)))),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBtn(BuildContext context) {
    if (!joined &&
        !controller.eventDetailModel.value.canJoin &&
        !controller.eventDetailModel.value.canCancel) {
      return Container();
    }
    if (controller.type == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ColorfulButton(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Obx(() => Text(
                  controller.eventDetailModel.value.canCancel ? 'CANCEL'.tr : "JOIN".tr,
                  style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
                )),
          ),
          height: 48,
          onTap: () => controller.eventDetailModel.value.canCancel
              ? controller.cancelActivity()
              : controller.joinActivity(context),
        ),
      );
    } else {
      //代表比赛
      if (controller.eventDetailModel.value.team == false) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Obx(() => Text(
                    controller.eventDetailModel.value.canCancel ? 'CANCEL'.tr : "JOIN".tr,
                    style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
                  )),
            ),
            height: 48,
            onTap: () => controller.eventDetailModel.value.canCancel
                ? controller.cancelActivity()
                : controller.joinMatch(context),
          ),
        );
      } else {
        return JoinButton(eventDetailModel: controller.eventDetailModel.value);
      }
    }
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(45),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: AppColor.background),
          child: Column(
            children: [
              SizedBox(
                width: 10,
                height: 6,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(children: [
                  TabBar(
                    controller: controller.tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white38,
                    indicatorColor: AppColor.yellow,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator:
                        HomeIndicator(borderSide: BorderSide(width: 4.0.w, color: AppColor.yellow)),
                    indicatorWeight: 4,
                    indicatorPadding: EdgeInsets.only(bottom: 2),
                    labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                    labelStyle: TextStyle(fontSize: 16, fontFamily: FONT_MEDIUM),
                    unselectedLabelStyle: TextStyle(fontSize: 18.sp, fontFamily: FONT_MEDIUM),
                    tabs: createTabs(),
                  )
                ]),
              ),
            ],
          )),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    for (String tab in controller.tabs) {
      tabs.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(tab),
      ));
    }
    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabOverviewPage()));
    pages.add(KeepAliveWrapper(child: TabRulesPage()));
    pages.add(KeepAliveWrapper(child: TabParticipantsPage()));
    if (controller.type == 1) {
    } else {
      pages.add(KeepAliveWrapper(child: TabPrizePage()));
    }

    return pages;
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class EventPageController extends BasePageController {
  late TabController tabController;

  late ScrollController scrollController;

  var title = "".obs;

  var titleColor = Colors.transparent.obs;

  var headerHeight = 300.0.obs;

  RxList<String> tabs = RxList();

  Rx<EventDetailModel> eventDetailModel = Rx(EventDetailModel());

  var userController = Get.find<UserController>();

  late int id;
  late int type;

  EventPageController({required this.id, required this.type});

  void changeTitleColor(Color titleColor) {
    this.titleColor.value = titleColor;
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >= headerHeight.value - kToolbarHeight) {
        if (titleColor.value == Colors.transparent) {
          changeTitleColor(Colors.white);
        }
      } else {
        if (titleColor.value == Colors.white) {
          changeTitleColor(Colors.transparent);
        }
      }
    });
    initData();

  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    dismissLoading();
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    if (type == 1) {
      eventDetailModel.value = await EventsApi.getActivityDetail(id);
    } else {
      eventDetailModel.value = await EventsApi.getMatchDetail(id);
    }
  }

  void initData() async {
    EventDetailModel model;
    if (type == 1) {
      model = await EventsApi.getActivityDetail(id);
      initTabs(model);
    } else {
      model = await EventsApi.getMatchDetail(id);
      initTabs(model);
    }
    tabController = TabController(length: tabs.length, initialIndex: 0, vsync: this);
    title.value = model.title;
    eventDetailModel.value = model;
  }

  void initTabs(EventDetailModel model) {
    tabs.add("Overview".tr);
    tabs.add("Rules".tr);
    if (model.matchDiff == TYPE_PRIZE) {
      tabs.add("Result".tr);
    } else {
      tabs.add("Participants".tr);
    }
    if(model.matchDiff==0||model.matchDiff==6){
      tabs.add("Prizes".tr);
    }
  }

  chooseTime() async {
    var startTime = eventDetailModel.value.kopStartTime;
    var endTime = eventDetailModel.value.kopEndTime;
    flog(
        'startTime ${TimeUtils.getYYYYMMDDHHMMSS(DateTime.fromMillisecondsSinceEpoch(startTime * 1000), '_', '_')}');
    flog(
        'endTime ${TimeUtils.getYYYYMMDDHHMMSS(DateTime.fromMillisecondsSinceEpoch(endTime * 1000), '_', '_')}');
    flog('间隔 ${(endTime - startTime) / 60}');
    if (endTime <= startTime || (endTime - startTime) / 60 < 15) {
      return startTime;
    }
    //计算时间区间
    var timesection = 60 * 15; //间隔是十五分钟
    List timeSections = [];
    for (int i = startTime; i < endTime; i += timesection) {
      flog(
          'i;${TimeUtils.getYYYYMMDDHHMMSS(DateTime.fromMillisecondsSinceEpoch(i * 1000), '-', ':')}');
      timeSections.add(i);
    }

    var result = await Get.bottomSheet(
        ListView(
          children: timeSections
              .map((e) => TextButton(
                  onPressed: () => Get.back(result: e),
                  child: Text(
                    '${TimeUtils.getYYYYMMDDHHMM(DateTime.fromMillisecondsSinceEpoch(e * 1000), '-', ':')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )))
              .toList(),
        ),
        backgroundColor: AppColor.itemBg);
    flog('result=$result');
    return result;
  }

  void joinActivity(BuildContext context) async {
    flog('joinActivity');
    userController.checkLogin(() async {
      if (eventDetailModel.value.matchDiff == 5) {
        var res = await showSheet(
            builder: (_) => EventSelectoWidget(
                  'Choose a Store'.tr,
                  selectorList: eventDetailModel.value.location,
                ));
        if (res != null) {
          var store = res['location'] as LocationModel;
          var time = res['time'] as DateTime;
          var timeSplit = time.toString().split(':');
          timeSplit.removeLast();
          var dateTime = timeSplit.join(':');
          checkFee(() async {
            showLoading();
            await EventsApi.joinActivity(
                eventDetailModel.value.id, userController.user.value.id, store.id,
                memberCouponId: eventDetailModel.value.memberCouponId,
                cupsleeve: dateTime);
            eventDetailModel.value = await EventsApi.getActivityDetail(id);
            dismissLoading();
            Get.dialog(
                ConfirmDialog(
                    title: "Congratulations".tr, info: "You have successfully signed up!".tr),
                barrierColor: Colors.black26);
          });
        }
      } else {
        SelectorItem? item;
        if (eventDetailModel.value.location.length > 1) {
          item = await SelectorDialog.show(context, eventDetailModel.value.location,
              title: "Select Location".tr);
        } else {
          item = eventDetailModel.value.location[0];
        }
        if (item != null) {
          LocationModel store = item as LocationModel;
          checkFee(() async {
            showLoading();
            await EventsApi.joinActivity(
                eventDetailModel.value.id, userController.user.value.id, store.id,  memberCouponId: eventDetailModel.value.memberCouponId,);

            eventDetailModel.value = await EventsApi.getActivityDetail(id);
            dismissLoading();
            Get.dialog(
                ConfirmDialog(
                    title: "Congratulations".tr, info: "You have successfully signed up!".tr),
                barrierColor: Colors.black26);
          });
        }
      }
    });
  }

  cancelActivity() async {
    showLoading();
  var resp=  await EventsApi.cancelActivity(eventDetailModel.value.id);
   showSuccess(resp.statusMessage);
   onRefresh();
    // Get.dialog(ConfirmDialog(title: "Confirm".tr, info: "Successfully Canceled!".tr),
    //     barrierColor: Colors.black26);
    dismissLoading();
  }

  void joinMatch(BuildContext context) async {
    int type = eventDetailModel.value.matchDiff;
    var timeResult;
    if (type == 5) {
      timeResult = await chooseTime();
      if (timeResult == null) {
        showToast('PLease Choose Time First'.tr);
        return;
      }
    }
    userController.checkLogin(() async {
      SelectorItem? item;
      if (eventDetailModel.value.location.length > 1) {
        if(eventDetailModel.value.matchDiff==TYPE_PRIZE) {
          item = LocationModel(5); //抽奖默认5
        }else {
          item = await SelectorDialog.show(context, eventDetailModel.value.location,
              title: "Select Location".tr);
        }
      } else {
        item = eventDetailModel.value.location[0];
      }
      //
      if (item != null) {
        LocationModel store = item as LocationModel;
        checkFee(() async {
          showLoading();
          await EventsApi.joinMatch(
              eventDetailModel.value.id, userController.user.value.id, store.id,
              memberCouponId: eventDetailModel.value.memberCouponId,
              cupsleeve: timeResult == null
                  ? null
                  : TimeUtils.getYYYYMMDDHHMM(
                      DateTime.fromMillisecondsSinceEpoch(timeResult * 1000), '-', ':'));
          eventDetailModel.value.canCancel = true;
          dismissLoading();
          Get.dialog(
              ConfirmDialog(
                  title: "Congratulations".tr, info: "You have successfully signed up!".tr),
              barrierColor: Colors.black26);
        });
      }
    });
  }

  void viewTeam() {
    Get.to(() => TeamPage(
          eventId: id,
        ));
  }

  void checkFee(Function checkDone) {
    if (eventDetailModel.value.fee > 0) {
     Get.bottomSheet(CheckFeeWidget(checkDone));
/*      String tips =
          "${'We will charge a deposit of £'.tr}${eventDetailModel.value.fee} ${'from your balance for this sign up, Please make sure that you have enough balance.'.tr}";
      Get.bottomSheet(
          ConfirmDialog(title: "Deposit Required".tr, info: tips),
              barrierColor: Colors.black26)
          .then((value) {
        if (value == true) {
          UserController userController = Get.find<UserController>();
          double userBalance = double.parse(userController.userProfile.balance);
          if (userBalance >= eventDetailModel.value.fee) {
            checkDone.call();
          } else {
            Get.to(() => BalancePage(
                  amount: eventDetailModel.value.fee.toDouble(),
                ));
          }
        }
      });*/
    } else {
      checkDone.call();
    }
  }

}
