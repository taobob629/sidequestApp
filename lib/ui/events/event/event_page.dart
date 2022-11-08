import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/events_api.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/event_detail_model.dart';
import 'package:wy/model/selector_item.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/flexible_header.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/events/event/event_selecto_widget.dart';
import 'package:wy/ui/events/event/team_page.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/widget/views.dart';

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
      body: NestedScrollView(
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
                      : FlexibleHeader(
                          image: controller.eventDetailModel.value.image,
                        ));
            }),
            SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(child: _buildTabBar())),
          ];
        },
        body: Container(
          padding: const EdgeInsets.only(top: 1),
          child: TabBarView(
              controller: controller.tabController, children: createPages()),
        ),
      ),
      floatingActionButton: Obx(() => _buildBtn(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  controller.eventDetailModel.value.canCancel
                      ? 'CANCEL'
                      : "JOIN",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "DIN", fontSize: 18),
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
                    controller.eventDetailModel.value.canCancel
                        ? 'CANCEL'
                        : "JOIN",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "DIN", fontSize: 18),
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
      if (controller.eventDetailModel.value.team == true) {
        //已经报名
        if (controller.eventDetailModel.value.team == true) {
          //比赛
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "VIEW MY TEAM",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "DIN", fontSize: 18),
                ),
              ),
              height: 48,
              onTap: () => controller.viewTeam(),
            ),
          );
        } else {
          //个人
          return Container();
        }
      } else {
        //没有报名
        if (controller.eventDetailModel.value.team == true) {
          //团队

        } else {
          //个人
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Obx(() => Text(
                      controller.eventDetailModel.value.canCancel
                          ? 'CANCEL'
                          : "JOIN",
                      style: TextStyle(
                          color: Colors.white, fontFamily: "DIN", fontSize: 18),
                    )),
              ),
              height: 48,
              onTap: () => controller.joinMatch(context),
            ),
          );
        }
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
                    indicatorColor: Colors.white38,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: HomeIndicator(),
                    indicatorWeight: 4,
                    indicatorPadding: EdgeInsets.only(bottom: 2),
                    labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                    labelStyle:
                        const TextStyle(fontSize: 18, fontFamily: "din"),
                    unselectedLabelStyle:
                        const TextStyle(fontSize: 18, fontFamily: "din"),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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

class EventPageController extends GetxController
    with SingleGetTickerProviderMixin {
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
    tabController =
        TabController(length: tabs.length, initialIndex: 0, vsync: this);
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    EasyLoading.dismiss(animation: false);
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void initData() async {
    tabs.add("Overview");
    tabs.add("Rules");
    tabs.add("Participants");
    EventDetailModel model;
    EasyLoading.show();
    if (type == 1) {
      model = await EventsApi.getActivityDetail(id);
    } else {
      tabs.add("Prizes");
      model = await EventsApi.getMatchDetail(id);
    }
    EasyLoading.dismiss();
    title.value = model.title;
    eventDetailModel.value = model;
  }

  void joinActivity(BuildContext context) async {
    userController.checkLogin(() async {
      if (eventDetailModel.value.matchDiff == 5) {
        var res = await showSheet(
            builder: (_) => EventSelectoWidget(
                  'Choose a Store',
                  selectorList: eventDetailModel.value.location,
                ));
        if (res != null) {
          var store = res['location'] as LocationModel;
          var time = res['time'] as DateTime;
          var timeSplit = time.toString().split(':');
          timeSplit.removeLast();
          var dateTime = timeSplit.join(':');
          checkFee(() async {
            EasyLoading.show();
            await EventsApi.joinActivity(eventDetailModel.value.id,
                userController.user.value.id, store.id,
                cupsleeve: dateTime);
            eventDetailModel.value = await EventsApi.getActivityDetail(id);
            EasyLoading.dismiss();
            Get.dialog(
                ConfirmDialog(
                    title: "Congratulations",
                    info: "You have successfully signed up!"),
                barrierColor: Colors.black26);
          });
        }
      } else {
        SelectorItem? item;
        if (eventDetailModel.value.location.length > 1) {
          item = await SelectorDialog.show(
              context, eventDetailModel.value.location,
              title: "Select Location");
        } else {
          item = eventDetailModel.value.location[0];
        }
        if (item != null) {
          LocationModel store = item as LocationModel;
          checkFee(() async {
            EasyLoading.show();
            await EventsApi.joinActivity(eventDetailModel.value.id,
                userController.user.value.id, store.id);
            eventDetailModel.value = await EventsApi.getActivityDetail(id);
            EasyLoading.dismiss();
            Get.dialog(
                ConfirmDialog(
                    title: "Congratulations",
                    info: "You have successfully signed up!"),
                barrierColor: Colors.black26);
          });
        }
      }
    });
  }

  cancelActivity() async {
    EasyLoading.show();
    await EventsApi.cancelActivity(eventDetailModel.value.id);
    if (eventDetailModel.value.team == false) {
      eventDetailModel.value = await EventsApi.getActivityDetail(id);
    } else {
      eventDetailModel.value = await EventsApi.getMatchDetail(id);
    }
    Get.dialog(ConfirmDialog(title: "Confirm", info: "Successfully Canceled!"),
        barrierColor: Colors.black26);
    EasyLoading.dismiss();
  }

  void joinMatch(BuildContext context) async {
    userController.checkLogin(() async {
      SelectorItem? item;
      if (eventDetailModel.value.location.length > 1) {
        item = await SelectorDialog.show(
            context, eventDetailModel.value.location,
            title: "Select Location");
      } else {
        item = eventDetailModel.value.location[0];
      }
      if (item != null) {
        LocationModel store = item as LocationModel;
        checkFee(() async {
          EasyLoading.show();
          await EventsApi.joinMatch(eventDetailModel.value.id,
              userController.user.value.id, store.id);
          eventDetailModel.value.canCancel = true;
          EasyLoading.dismiss();
          Get.dialog(
              ConfirmDialog(
                  title: "Congratulations",
                  info: "You have successfully signed up!"),
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
      String tips =
          "We will charge a deposit of £ ${eventDetailModel.value.fee} from your balance for this sign up, Please make sure that you have enough balance.";
      Get.dialog(ConfirmDialog(title: "Deposit Required", info: tips),
              barrierColor: Colors.black26)
          .then((value) {
        if (value == true) {
          UserController userController = Get.find<UserController>();
          double userBalance =
              double.parse(userController.userInfoModel.value.balance);
          if (userBalance >= eventDetailModel.value.fee) {
            checkDone.call();
          } else {
            Get.to(() => BalancePage(
                  amount: eventDetailModel.value.fee.toDouble(),
                ));
          }
        }
      });
    } else {
      checkDone.call();
    }
  }
}
