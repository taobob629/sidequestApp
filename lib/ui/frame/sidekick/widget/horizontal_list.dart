/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/utils.dart';

class HorizontalGameListWidget extends StatelessWidget {
  //滑动控制器
  ScrollController _scrollController = new ScrollController()
    ..addListener(() {
      flog('scroll');
    });
  int _currentSelectIndex = 0;
  RxBool _needRefresh = RxBool(false);

  bool get needRefresh => _needRefresh.value;

  set needRefresh(bool value) {
    _needRefresh.value = value;
  }

  update() {
    needRefresh = !needRefresh;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: NotificationListener<ScrollEndNotification>(
            //通知兼听
            onNotification: (ScrollNotification scrollNotification) {
              //滑动信息封装
              ScrollMetrics metrics = scrollNotification.metrics;
              //获取当前的滑动位置
              double pixels = metrics.pixels;
              //最大可滑动距离
              double maxScrollExtent = metrics.maxScrollExtent;
              //计算滑动位置
              double scrollIndex = pixels / _itemWidth;
              double scrollOffset = pixels % _itemWidth;
              //当前选中
              _currentSelectIndex = scrollIndex.round();

              if (pixels == maxScrollExtent) {
              } else if (pixels == 0) {
              } else {
                if (scrollOffset != 0.0) {
                  Future.delayed(Duration.zero, () {
                    _scrollController.animateTo(
                      _currentSelectIndex * _itemWidth,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  });
                } else {}
              }
              update();
              return true;
            },
            child: Obx(() => SingleChildScrollView(
                  controller: _scrollController,
                  //滑动方向 为水平 方向
                  scrollDirection: needRefresh ? Axis.horizontal : Axis.horizontal,
                  child: Row(
                    children: buildChildren(),
                  ),
                ))));
  }

  buildChildren() {
    List<Widget> list = [];
    for (int i = 0; i < 20; i++) {
      list.add(buildItemWidget(i));
    }
    return list;
  }

  double _itemWidth = 0.0;

  Widget buildItemWidget(int index) {
    //一页显示5个
    _itemWidth = Get.size.width / 5;

    Color textColor = Colors.grey;
    double fontSize = 14;
    double imageWidth = 55.0;
    flog('update---');
    //当控制器绑定成功后再使用
    if (_scrollController.hasClients) {
      //获取当前滑动的距离
      double offset = _scrollController.offset;
      double scorllIndex = offset / _itemWidth;
      //1.9 -2.0
      double uniWidth = scorllIndex - scorllIndex.round();
      if ((scorllIndex.round() + 2) == index) {
        textColor = Colors.redAccent;
        fontSize = 16;
        imageWidth = 55.0 + 20 * (1.0 - uniWidth);
      } else if ((scorllIndex.round() + 3) == index) {
        imageWidth = 55.0 + 20 * uniWidth;
      }
    }

    return Container(
      width: _itemWidth,
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //裁剪圆形
          ClipOval(
            child: ImageUtil.assetImage('ic_coupons_new',width: imageWidth),
          ),
          //图片
          //文字
          Text(
            "测试$index",
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
