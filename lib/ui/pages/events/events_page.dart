import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/events/tab_activity_page.dart';
import 'package:sq_hub_app/ui/pages/events/tab_match_page.dart';

import '../../../api/wy_http.dart';
import '../../../common/activity_item.dart';
import '../../../common/empty_view.dart';
import '../../../common/keep_alive_wrapper.dart';
import '../../../model/activity_item_model.dart';
import '../../../model/data_model.dart';
import '../../../utils/utils.dart';
import '../../../widget/anima_switch_widget.dart';
import '../../../widget/mylistview.dart';
import '../../../widget/tab_widget.dart';

///事件选项卡
var eventTabDm = DataModel();
Future<int> eventTab(Function fun) async {
  await http.get('/app/events/26/eventTab').then((res) async {
    eventTabDm.addList(res.data, true, 0);
  }).catchError((e) {
    eventTabDm.toError();
  });
  flog(eventTabDm.toJson(), 'eventTabDm');
  fun();
  return eventTabDm.flag;
}

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
    eventTab(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder<dynamic>(
      value: eventTabDm,
      errorOnTap: () => eventTab(() => setState(() {})),
      noDataView: EmptyView(),
      listBuilder: (list, p, h) {
        var tabList = list.map<String>((m) => m['name']).toList();
        var page = list.indexWhere((w) => w['defaut'] == 1);
        return TabWidget(
          tabList: tabList,
          tabstyle: TAB_STYLE_1,
          page: page == -1 ? 0 : page,
          tabPage: List.generate(list.length, (i) {
            return EventsChild(list[i]);
          }),
        );
      },
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Events".tr,
    ));
    tabs.add(Text(
      "Tournaments".tr,
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
  final bool isMe;
  const EventsChild(this.data, {Key? key, this.isMe = false}) : super(key: key);
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
    var matchDiff = widget.data['type'];
    var path = [
      [
        '/app/events/26/userMatches?matchDiff=$matchDiff',
        '/app/events/26/userActivities?matchDiff=$matchDiff',
      ][matchDiff == '0' ? 0 : 1],
      '/app/events/26/webActivities?matchDiff=$matchDiff',
    ][widget.isMe ? 0 : 1];
    await http.get(path).then((res) async {
      if (widget.isMe) {
        var list = res.data as List;
        webActivitiesDm.addList(list.map((m) => ActivityItemModel.fromJson(m)).toList(), true, 0);
      } else {
        var list = res.data['matchList'] as List;
        webActivitiesDm.addList(list.map((m) => ActivityItemModel.fromJson(m)).toList(), true, 0);
      }
    }).catchError((e) {
      flog(e);
      webActivitiesDm.toError();
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
