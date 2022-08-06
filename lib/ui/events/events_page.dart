import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/activity_item.dart';
import 'package:wy/ui/events/tab_activity_page.dart';
import 'package:wy/ui/events/tab_match_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/tab_widget.dart';
import '../../model/activity_item_model.dart';
import '../../model/data_model.dart';
import '../../widget/mylistview.dart';
import '../common/empty_view.dart';

class EventsPage extends StatefulWidget {
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final controller = Get.put(EventsPageController());

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    this.eventTab();
  }

  ///事件选项卡
  var eventTabDm = DataModel();
  Future<int> eventTab() async {
    await http.get('/app/events/26/eventTab').catchError((e) {
      eventTabDm.toError();
    }).then((res) async {
      eventTabDm.addList(res.data, true, 0);
    });
    flog(eventTabDm.toJson(), 'eventTabDm');
    setState(() {});
    return eventTabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder<dynamic>(
      value: eventTabDm,
      errorOnTap: () => this.eventTab(),
      noDataView: EmptyView(),
      listBuilder: (list, p, h) {
        var tabList = list.map<String>((m) => m['name']).toList();
        var page = list.indexWhere((w) => w['defaut'] == 1);
        return ScaffoldWidget(
          appBar: statusBar(),
          body: TabWidget(
            tabList: tabList,
            page: page == -1 ? 0 : page,
            tabPage: List.generate(list.length, (i) {
              return EventsChild(list[i]);
            }),
          ),
        );
        // return Scaffold(
        //   backgroundColor: Colors.transparent,
        //   appBar: PreferredSize(
        //       preferredSize: const Size.fromHeight(40),
        //       child: Container(
        //         child: SafeArea(
        //             child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Spacer(),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 10),
        //               child: Row(
        //                 children: [
        //                   TabBar(
        //                     controller: controller.tabController,
        //                     isScrollable: true,
        //                     labelColor: Colors.white,
        //                     unselectedLabelColor: Colors.white38,
        //                     indicatorColor: Colors.white38,
        //                     indicatorSize: TabBarIndicatorSize.label,
        //                     indicator: HomeIndicator(),
        //                     indicatorWeight: 4,
        //                     indicatorPadding: EdgeInsets.only(bottom: 5),
        //                     labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
        //                     labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
        //                     unselectedLabelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
        //                     tabs: createTabs(),
        //                   ),
        //                   Spacer(),
        //                 ],
        //               ),
        //             )
        //           ],
        //         )),
        //       )),
        //   body: TabBarView(
        //     controller: controller.tabController,
        //     physics: PagePhysics(),
        //     children: createPages(),
        //   ),
        // );
      },
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Events",
    ));
    tabs.add(Text(
      "Tournaments",
    ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabActivityPage()));
    pages.add(KeepAliveWrapper(child: TabMatchPage()));
    return pages;
  }
}

class EventsPageController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class EventsChild extends StatefulWidget {
  final Map data;
  const EventsChild(this.data, {Key? key}) : super(key: key);
  @override
  _EventsChildState createState() => _EventsChildState();
}

class _EventsChildState extends State<EventsChild> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.webActivities();
  }

  ///网络活动
  var webActivitiesDm = DataModel<ActivityItemModel>();
  Future<int> webActivities() async {
    await http.get('/app/events/26/webActivities?matchDiff=${widget.data['type']}').catchError((e) {
      webActivitiesDm.toError();
    }).then((res) async {
      var list = res.data['matchList'] as List;
      webActivitiesDm.addList(list.map((m) => ActivityItemModel.fromJson(m)).toList(), true, 0);
    });
    setState(() {});
    return webActivitiesDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitchBuilder<ActivityItemModel>(
      value: webActivitiesDm,
      isRef: true,
      errorOnTap: () => this.webActivities(),
      noDataView: EmptyView(),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          value: webActivitiesDm,
          onRefresh: () => this.webActivities(),
          onLoading: () => this.webActivities(),
          item: (i) => ActivityItem(model: list[i], type: int.parse(widget.data['type'])),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
