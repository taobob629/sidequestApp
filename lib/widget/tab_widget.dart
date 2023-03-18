import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/utils/index.dart';

import '../ui/common/home_indicator.dart';
import 'custom_scroll_physics.dart';
import 'my_bouncing_scroll_physics.dart';

const int TAB_STYLE_DEFAULT = 0;
const int TAB_STYLE_1 = 1;
const int TAB_STYLE_2 = 2;

class TabWidget extends StatefulWidget {
  final List? tabList;
  final List<Widget>? tabPage;
  final bool isScrollable;
  final ScrollPhysics? pagePhysics;
  final TabBarIndicatorSize indicatorSize;
  final Decoration? indicator;
  final int? page;
  final Color? color;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final int tabstyle;
  final TabController? tabController;
  final Alignment alignment;

  const TabWidget({
    Key? key,
    this.tabList,
    this.tabstyle = TAB_STYLE_DEFAULT,
    this.alignment = Alignment.center,
    this.tabPage,
    this.tabController,
    this.isScrollable = true,
    this.pagePhysics,
    this.page = 0,
    this.color,
    this.fontSize,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.indicator = const HomeIndicator(),
    this.padding,
  }) : super(key: key);

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  TabController? tabCon;
  RxString _tabIndex = RxString('');

  String get tabIndex => _tabIndex.value;

  set tabIndex(String value) {
    _tabIndex.value = value;
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    tabIndex = widget.tabList![0];
    tabCon = TabController(vsync: this, length: widget.tabList!.length, initialIndex: widget.page!)
      ..addListener(() {
        tabIndex = widget.tabList![tabCon?.index ?? 0];
      });
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
            controller: widget.tabController ?? tabCon,
            children: widget.tabPage!,
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          alignment: widget.alignment,
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.white24),
            child: TabBar(
              controller: widget.tabController ?? tabCon,
              isScrollable: widget.isScrollable,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              indicatorColor: Colors.white38,
              indicatorWeight: 0,
              indicatorSize: widget.indicatorSize,
              indicator: widget.indicator,
              // indicatorWeight: 4,
              // indicatorPadding: EdgeInsets.only(bottom: 5),
              labelPadding: widget.padding ?? const EdgeInsets.fromLTRB(10, 0, 10, 3),
              labelStyle: selectTabStyle(),
              unselectedLabelStyle: unSelectTabStyle(),
              tabs: buildTabs(),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle selectTabStyle() {
    switch (widget.tabstyle) {
      case TAB_STYLE_2:
        return TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold,fontFamily: FONT_MEDIUM);
      case TAB_STYLE_1:
        return const TextStyle(fontSize: 14,fontFamily: FONT_MEDIUM);
      case TAB_STYLE_DEFAULT:
      default:
        return const TextStyle(fontSize: 14,fontFamily: FONT_MEDIUM);
    }
  }

  TextStyle unSelectTabStyle() {
    switch (widget.tabstyle) {
      case TAB_STYLE_2:
        return const TextStyle(fontSize: 14,fontFamily: FONT_MEDIUM);
      case TAB_STYLE_1:
        return const TextStyle(fontSize: 14,fontFamily: FONT_MEDIUM);
      case TAB_STYLE_DEFAULT:
      default:
        return const TextStyle(fontSize: 14,fontFamily: FONT_MEDIUM);
    }
  }

  List<Widget> buildTabs() {
    switch (widget.tabstyle) {
      case TAB_STYLE_1:
        return widget.tabList!.map((m) {
          return Obx(() => Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23).r,
                    gradient: tabIndex == m
                        ? LinearGradient(colors: [
                            Color(0xFF612AD7),
                            Color(0xFFBE39CC),
                            Color(0xFFE68887),
                          ])
                        : LinearGradient(colors: [AppColor.tabBackGround, AppColor.tabBackGround])),
                child: Tab(
                  text: '$m',
                ),
              ));
        }).toList();
      case TAB_STYLE_DEFAULT:
      default:
        return widget.tabList!
            .map((m) => Tab(
                  text: '$m',
                ))
            .toList();
    }
  }
}
