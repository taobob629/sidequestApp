import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:wy/ui/frame/messages/chat/conversation_list_page.dart';
import '../../common/keep_alive_wrapper.dart';
import '../common/home_indicator.dart';
import '../controller/user_controller.dart';

class PlayPage extends StatelessWidget {
  final controller = Get.put(PlayPageController());
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      TabBar(
                        controller: controller.tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white38,
                        indicatorColor: Colors.white38,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: HomeIndicator(),
                        indicatorWeight: 4,
                        indicatorPadding: EdgeInsets.only(bottom: 5),
                        labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                        labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                        unselectedLabelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                        tabs: createTabs(),
                      ),
                    ],
                  ),
                )
              ],
            )),
          )),
      body: TabBarView(controller: controller.tabController, children: createPages()),
    );
  }

  List<Widget> createPages() {
    List<Widget> pages = [];

    Widget page = Obx(() => userController.imLoginDone.value ? ConversationListPage() : Container());
    pages.add(KeepAliveWrapper(child: page));
    return pages;
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Messages".tr,
    ));
    return tabs;
  }
}

class PlayPageController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  TIMUIKitConversationController conversationController = TIMUIKitConversationController();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 1, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
  }
}
