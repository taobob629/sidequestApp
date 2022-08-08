// ignore_for_file: dead_code, implementation_imports
import 'package:flutter_easyloading/src/widgets/indicator.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/sheet_widget.dart';
import 'package:wy/widget/widget_tap.dart';
import '../model/data_model.dart';
import '../utils/utils.dart';
import 'CPicker_widget.dart';
import 'anima_switch_widget.dart';
import 'button.dart';
import 'my_classicHeader.dart' as myh;
import 'mylistview.dart';
import 'mytext.dart';

///屏幕宽高
Size size(context) => MediaQuery.of(context).size;

///屏幕顶部和底部
EdgeInsets padd(context) => MediaQuery.of(context).padding;

///屏幕宽高
Size get pmSize => MediaQuery.of(context!).size;

///屏幕顶部和底部
EdgeInsets get pmPadd => MediaQuery.of(context!).padding;

///选择器
Future showSelecto(
  BuildContext context, {
  void Function(String, int)? callback,
  List texts = const ['不限', '1~3', '3~5'],
  int index = 0,
}) {
  var value = texts.first;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (_) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          height: size(context).height / 3,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        print(index);
                        print(value.toString());
                        callback!(value.toString(), index);
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CPickerWidget(
                  backgroundColor: Colors.white,
                  scrollController: FixedExtentScrollController(initialItem: index),
                  onSelectedItemChanged: (i) {
                    index = i;
                    value = texts[i];
                  },
                  children: texts.map((v) {
                    return Text(
                      v.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///选择器
Future showSelectoBtn(
  BuildContext context, {
  void Function(String, int)? callback,
  List texts = const ['不限', '1~3', '3~5'],
  List<Widget> icons = const [],
  bool isDark = true,
  dynamic value,
}) {
  // var value = texts.first;
  // var index = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showSheetWidget(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          // height: size(context).width / 1.5,
          color: isDark ? Color(0xFF545454) : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyListView(
                isShuaxin: false,
                flag: !false,
                listViewType: ListViewType.Separated,
                divider: Divider(height: 0, color: isDark ? Colors.white10 : Colors.black12),
                itemCount: texts.length,
                animationDelayed: 0,
                animationType: AnimationType.close,
                physics: NeverScrollableScrollPhysics(),
                item: (i) {
                  return WidgetTap(
                    isElastic: true,
                    onTap: () {
                      close();
                      callback!(texts[i], i);
                    },
                    child: Opacity(
                      opacity: value == null ? 1 : (value == texts[i] ? 1 : 0.25),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icons.length >= texts.length ? icons[i] : PWidget.boxw(0),
                            MyText(
                              texts[i],
                              size: 16,
                              color: !isDark ? Color(0xFF545454) : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                height: 0,
                thickness: 4,
                color: isDark ? Colors.white.withOpacity(0.025) : Colors.black.withOpacity(0.025),
              ),
              WidgetTap(
                isElastic: true,
                onTap: () => close(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  color: isDark ? Color(0xFF545454) : Colors.white,
                  alignment: Alignment.center,
                  child: MyText('取消', size: 16, color: !isDark ? Color(0xFF545454) : Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///选择器
Future showSelectoindex(
  BuildContext context, {
  void Function(String)? callback,
  List texts = const ['不限', '1~3', '3~5'],
}) {
  var value = 0;
  FocusScope.of(context).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      callback!(value.toString());
                    },
                    child: Text(
                      '确认',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 48,
                magnification: 1.25,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onSelectedItemChanged: (i) => value = i,
                children: texts.map((v) {
                  return Center(
                    child: Text(
                      v.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

///底部悬浮菜单
Future<dynamic> showSheet({
  List<Widget> children = const <Widget>[],
  Widget Function(ScrollController?)? builder,
  bool? isScrollControlled,
  bool isDraggableList = !true,
  bool isClose = false,
  Color? barrierColor,
}) {
  FocusScope.of(context!).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: context!,
    isDismissible: !isClose,
    enableDrag: !isClose,
    barrierColor: barrierColor,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled ?? true,
    builder: (_) {
      return WillPopScope(
        child: AnimatedPadding(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          // padding: Platform.version.contains('2.13') ? EdgeInsets.zero : MediaQuery.of(context).viewInsets,
          padding: Platform.version.contains('2.13') ? EdgeInsets.zero : EdgeInsets.zero,
          child: builder!(null),
        ),
        onWillPop: () async => !isClose,
      );
    },
  );
}

///加载框
buildShowDialog(
  context, {
  isClose = false,
  String? text,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: isClose, //x点击空白关闭
    builder: (_) => WillPopScope(
      onWillPop: () async => isClose,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          if (text != null) SizedBox(height: 8),
          if (text != null) MyText(text.toString(), color: Colors.white)
        ],
      ),
    ),
  );
}

///加载框
Widget buildLoad({
  ///大小
  double size = 40,
  double radius = 10,

  ///粗细
  double width = 2,

  ///是否居中
  bool isCenter = true,

  ///颜色
  Color? color,
}) {
  if (isCenter) {
    // return Center(
    //   child: CupertinoActivityIndicator(radius: radius),
    // );
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: Center(
          child: LoadingIndicator(),
          // child: CircularProgressIndicator(
          //   strokeWidth: 2,
          //   valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context!).primaryColor),
          // ),
        ),
      ),
    );
  } else {
    // return CupertinoActivityIndicator(radius: radius);
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: LoadingIndicator(),
        // child: CircularProgressIndicator(
        //   strokeWidth: 2,
        //   valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context!).primaryColor),
        // ),
      ),
    );
  }
}

///上拉加载更多的底部
CustomFooter buildCustomFooter({
  Color? color,
  String? text,
}) {
  color = color ?? Colors.white54;
  var dataModel = DataModel(flag: 3);
  return CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = Text("pull up to load more!", style: TextStyle(color: color), key: ValueKey(1));
      } else if (mode == LoadStatus.loading) {
        body = SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: LoadingIndicator(),
            // child: CircularProgressIndicator(
            //   strokeWidth: 2,
            //   valueColor: AlwaysStoppedAnimation<Color>(color!.withOpacity(1)),
            // ),
          ),
        );
      } else if (mode == LoadStatus.canLoading) {
        body = Text("release", style: TextStyle(color: color), key: ValueKey(2));
      } else if (mode == LoadStatus.failed) {
        body = Text(text ?? "load failed", style: TextStyle(color: color));
      } else if (mode == LoadStatus.noMore) {
        body = Text("release", style: TextStyle(color: color));
      }
      return Container(
        height: 56,
        child: AnimatedSwitchBuilder(
          value: dataModel,
          alignment: Alignment.center,
          defaultBuilder: () => body!,
          errorOnTap: () async => getTime(),
        ),
      );
    },
  );
}

///下拉刷新的头部
myh.MyClassicHeader buildClassicHeader({
  Color? color,
  String? text,
}) {
  color = color ?? Colors.white54;
  return myh.MyClassicHeader(
    height: 56.0,
    textStyle: TextStyle(color: color),
    releaseText: 'release refresh!',
    releaseIcon: null,
    completeText: 'refresh succeeded!',
    completeIcon: null,
    failedText: text ?? 'refresh failed!',
    failedIcon: null,
    idleText: 'pull down refresh!',
    idleIcon: null,
    refreshingText: null,
    refreshStyle: RefreshStyle.Follow,
    // refreshingIcon: Container(
    //   height: 24,
    //   child: LoadingIndicator(
    //     color: color.withOpacity(0.5),
    //     colors: [color.withOpacity(0.5)],
    //     indicatorType: Indicator.circleStrokeSpin,
    //   ),
    // ),
    refreshingIcon: SizedBox(
      height: 40,
      width: 40,
      child: Center(
        child: LoadingIndicator(),
        // child: CircularProgressIndicator(
        //   strokeWidth: 2,
        //   valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(1)),
        // ),
      ),
    ),
  );
}

Future showTc({
  String? title,
  String? content,
  String cancelText = '取消',
  String okText = '确定',
  Color? okColor,
  bool isDark = false,
  bool isAutoClose = true,
  bool isTips = false,
  bool isClose = true,
  bool isCenter = true,
  double? lineH,
  Widget? titleWidget,
  required Function() onPressed,
}) {
  FocusScope.of(context!).requestFocus(FocusNode());
  return showGeneralDialog(
    context: context!,
    barrierLabel: "你好",
    barrierColor: isMobile ? Colors.black.withOpacity(0.5) : Colors.black12,
    transitionDuration: Duration(milliseconds: 200),
    transitionBuilder: (_, a1, a2, child) {
      switch (a1.status) {
        case AnimationStatus.reverse:
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
            child: ScaleTransition(
              scale: Tween(begin: 0.9, end: 1.0).animate(a1),
              child: child,
            ),
          );
          break;
        default:
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(a1),
            child: ScaleTransition(
              scale: Tween(begin: 1.1, end: 1.0).animate(
                CurvedAnimation(parent: a1, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
      }
    },
    pageBuilder: (_, __, ___) {
      return WillPopScope(
        onWillPop: () => Future(() => isClose),
        child: GestureDetector(
          onTap: () {
            if (isClose) close();
          },
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : size(context).width / 3),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Theme.of(context!).scaffoldBackgroundColor : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          spreadRadius: -8,
                          color: Colors.black26,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (title != null)
                          Padding(
                            // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
                            padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: content == null ? 24 : 16),
                            child: MyText(
                              title,
                              size: 18,
                              // isBold: true,
                              isOverflow: false,
                              color: isDark ? Colors.white : Colors.black,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (titleWidget != null)
                          Padding(
                            // padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16)
                            padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: content == null ? 24 : 16),
                            child: titleWidget,
                          ),
                        if (content != null)
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: title == null && titleWidget == null ? 32 : 0),
                            child: MyText(
                              content,
                              // isBold: true,
                              color: (isDark ? Colors.white : Colors.black).withOpacity(0.5),
                              isOverflow: false,
                              height: lineH,
                              textAlign: isCenter ? TextAlign.center : TextAlign.left,
                            ),
                          ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          color: isDark ? Colors.white10 : Color(0x10000000),
                        ),
                        Row(
                          children: <Widget>[
                            if (!isTips)
                              Expanded(
                                child: Button(
                                  height: 48,
                                  onPressed: () => close(0),
                                  child: MyText(
                                    cancelText,
                                    // isBold: true,
                                    size: 16,
                                    color: isDark ? Colors.white70 : Colors.black,
                                  ),
                                ),
                              ),
                            if (!isTips) Container(height: 32, width: 1, color: isDark ? Colors.white10 : Color(0x10000000)),
                            Expanded(
                              child: Button(
                                height: 48,
                                onPressed: () {
                                  if (isAutoClose) close(1);
                                  onPressed();
                                },
                                child: MyText(
                                  okText,
                                  // isBold: true,
                                  size: 16,
                                  color: okColor ?? Theme.of(context!).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
