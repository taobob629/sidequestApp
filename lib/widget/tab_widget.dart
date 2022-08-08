import 'package:flutter/material.dart';

import '../ui/common/home_indicator.dart';
import 'custom_scroll_physics.dart';
import 'my_bouncing_scroll_physics.dart';

class TabWidget extends StatefulWidget {
  final List<String>? tabList;
  final List<Widget>? tabPage;
  final bool? isScrollable;
  final ScrollPhysics? pagePhysics;
  final int? page;
  final Color? color;
  final double? fontSize;

  const TabWidget({Key? key, this.tabList, this.tabPage, this.isScrollable, this.pagePhysics, this.page = 0, this.color, this.fontSize}) : super(key: key);
  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  TabController? tabCon;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = TabController(vsync: this, length: widget.tabList!.length, initialIndex: widget.page!);
  }

  @override
  void dispose() {
    tabCon?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: TabBarView(
            physics: widget.pagePhysics ?? const PagePhysics(parent: MyBouncingScrollPhysics()),
            controller: tabCon,
            children: widget.tabPage!,
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // color: widget.color ?? Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: -2,
                color: Colors.black12,
                offset: Offset(0, 2),
              ),
            ],
            // border: Border(
            //   bottom: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.15)),
            // ),
          ),
          child: TabBar(
            controller: tabCon,
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
            tabs: widget.tabList!.map((m) {
              return Tab(text: m);
            }).toList(),
          ),
          // child: TabBar(
          //   controller: tabCon,
          //   indicatorSize: TabBarIndicatorSize.label,
          //   // indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
          //   isScrollable: widget.isScrollable ?? true,
          //   indicatorWeight: 4,
          //   indicatorColor: Theme.of(context).primaryColor,
          //   unselectedLabelColor: Colors.black.withOpacity(0.5),
          //   unselectedLabelStyle: TextStyle(fontSize: widget.fontSize ?? 20),
          //   labelStyle: TextStyle(fontSize: widget.fontSize ?? 20),
          //   labelColor: Colors.black,
          //   tabs: widget.tabList!.map((m) {
          //     return Tab(text: m);
          //   }).toList(),
          // ),
        ),
      ],
    );
  }
}
