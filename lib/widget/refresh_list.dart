/**
    author:mac
    创建日期:2021/11/12
    描述:
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/app_color.dart';

typedef buildContent = Widget Function();

Widget biuldSmartRefresh(RefreshController? refreshController, Widget content,
    {required VoidCallback onRefresh,
    VoidCallback? onLoad,
    bool enablePullDown = true,
    bool enablePullUp = true,
    Color textColor = AppColor.textC5C5,
    Widget header = const WaterDropHeader(
        complete: Center(child: Text("", style: TextStyle(color: AppColor.textC5C5))))}) {
  return SmartRefresher(
    controller: refreshController!,
    enablePullUp: enablePullUp,
    enablePullDown: enablePullDown,
    header: header,
    footer: CustomFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(
            "Loading",
            style: TextStyle(color: textColor),
          );
        } else if (mode == LoadStatus.loading) {
          body = Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    strokeWidth: 1.6,
                  ),
                  width: 16,
                  height: 16,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text("Loading...", style: TextStyle(fontSize: 12, color: textColor))
              ],
            ),
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Text("", style: TextStyle(color: textColor));
        } else {
          body = Text("");
        }
        return Container(
          height: 50.0,
          child: Center(child: body),
        );
      },
    ),
    onRefresh: () async {
      onRefresh.call();
    },
    onLoading: () async {
      onLoad?.call();
    },
    child: content,
  );
}
