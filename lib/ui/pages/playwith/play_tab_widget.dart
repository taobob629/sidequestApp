import 'package:flutter/material.dart';
import 'package:sq_hub_app/ui/pages/playwith/scroll_monitor_widget.dart';

import '../../../common/home_indicator.dart';
import '../../../utils/utils.dart';
import '../../../widget/custom_scroll_physics.dart';
import '../../../widget/my_bouncing_scroll_physics.dart';
import '../../../widget/views.dart';

class PlayTabWidget extends StatefulWidget {
  final List<String>? tabList;
  final Widget Function(int, String)? tabBuilder;
  final List<Widget>? tabPage;
  final bool isScrollable;
  final ScrollPhysics? pagePhysics;
  final int? page;
  final Color? color;
  final double? fontSize;
  final bool isShowLeft;
  final Widget? rightChild;
  final ScrollController? controller;
  final TabController? tabCon;

  const PlayTabWidget({
    Key? key,
    this.tabList,
    this.tabPage,
    this.isScrollable = false,
    this.pagePhysics,
    this.page = 0,
    this.color,
    this.fontSize,
    this.tabBuilder,
    this.rightChild,
    this.controller,
    this.isShowLeft = true,
    this.tabCon,
  }) : super(key: key);
  @override
  _PlayTabWidgetState createState() => _PlayTabWidgetState();
}

class _PlayTabWidgetState extends State<PlayTabWidget> with TickerProviderStateMixin {
  TabController? tabCon;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabCon = widget.tabCon ?? TabController(vsync: this, length: widget.tabList!.length, initialIndex: widget.page!);
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
        TabBarView(
          physics: widget.pagePhysics ?? const PagePhysics(parent: MyBouncingScrollPhysics()),
          controller: tabCon,
          children: widget.tabPage!,
        ),
        ScrollMonitorWidget(
          controller: widget.controller,
          builder: (v) {
            return Container(
              height: padd(context).top + 48,
              padding: EdgeInsets.only(top: padd(context).top + 8),
              width: double.infinity,
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (widget.color ?? Colors.transparent),
              ),
              child: Row(
                children: [
                  if (widget.isShowLeft) SizedBox(width: 8),
                  if (widget.isShowLeft)
                    GestureDetector(
                      onTap: () => close(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Expanded(
                    child: TabBar(
                      controller: tabCon,
                      isScrollable: widget.isScrollable,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white38,
                      indicatorColor: Colors.white38,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: HomeIndicator(),
                      indicatorWeight: 0,
                      indicatorPadding: EdgeInsets.only(bottom: 5),
                      labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                      labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                      unselectedLabelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                      tabs: widget.tabList!.map((m) {
                        if (widget.tabBuilder == null) {
                          return Tab(text: m);
                        } else {
                          return widget.tabBuilder!(widget.tabList!.indexOf(m), m);
                        }
                      }).toList(),
                    ),
                  ),
                  if (widget.rightChild != null) widget.rightChild!,
                ],
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
            );
          },
        ),
      ],
    );
  }
}
