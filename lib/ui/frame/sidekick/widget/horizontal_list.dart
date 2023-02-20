/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/widget/views.dart';

class HorizontalGameListWidget extends StatelessWidget {
  SideKickController controller = Get.find<SideKickController>();

  //滑动控制器
  ScrollController _scrollController = new ScrollController()..addListener(() {});
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
              controller.currentSelectIndex = scrollIndex.round();
              if (pixels == maxScrollExtent) {
              } else if (pixels == 0) {
              } else {
                if (scrollOffset != 0.0) {
                  Future.delayed(Duration.zero, () {
                    _scrollController.animateTo(
                      controller.currentSelectIndex * _itemWidth,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  });
                } else {}
              }
              update();
              // flog('_cur${controller.currentSelectIndex}');
              return true;
            },
            child: Obx(() => SingleChildScrollView(
                  controller: _scrollController,
                  //滑动方向 为水平 方向
                  scrollDirection: needRefresh ? Axis.horizontal : Axis.horizontal,
                  child: Obx(() => controller.gameList.isEmpty
                      ? buildLoad()
                      : Row(
                          children: buildChildren(),
                        )),
                ))));
  }

  buildChildren() {
    List<Widget> list = [];
    for (int i = 0; i < controller.gameList.length; i++) {
      list.add(buildItemWidget(i));
    }
    return list;
  }

  double _itemWidth = Get.width / 4;

  Widget buildItemWidget(int index) {
    SimpleGameModel item = controller.gameList[index];
    double imageWidth = 76.0; //正常尺寸
    //当控制器绑定成功后再使用
    if (_scrollController.hasClients) {
      //获取当前滑动的距离
      double offset = _scrollController.offset;
      double scorllIndex = offset / _itemWidth;
      if ((scorllIndex.round()) == index) {
        imageWidth = 100.0.w;
      } else {
        imageWidth = 76.w;
      }
    } else {
      //默认第一个选中
      if (index == 0) {
        imageWidth = 100.0.w;
      }
    }
    return InkWell(
      onTap: () => controller.choseSelect(index),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)).w),
        width: _itemWidth,
        padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h, right: 2),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)).w,
          child: ImageUtil.networkImage(
              url: item.thumb ?? '', width: imageWidth, height: imageWidth, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
