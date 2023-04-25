import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/event_bus/beans/badge_event.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';

import '../../../../config/app_color.dart';
import '../../../../utils/image_util.dart';

class BadgeDetailWidget extends StatefulWidget {
  List<TrophieModel> trophies = [];

  BadgeDetailWidget(this.trophies);

  @override
  _BadgeDetailWidgetState createState() => _BadgeDetailWidgetState();
}

class _BadgeDetailWidgetState extends State<BadgeDetailWidget>
    with TickerProviderStateMixin {
  bool ifBig = true;

  double _scaleFactor = 1.0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _scaleFactorEnd = 2.0;
  late AnimationController _animationControllerEnd;
  late Animation<double> _animationEnd;

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    subscription = eventBus.on<BadgeEvent>().listen((event) {
      stop();
    });

    // 创建动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    // 创建动画
    _animation =
        Tween<double>(begin: 1.0, end: 2.0).animate(_animationController)
          ..addListener(() {
            setState(() {
              _scaleFactor = _animation.value;
            });
          });

    // 创建动画控制器
    _animationControllerEnd = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    // 创建动画
    _animationEnd =
        Tween<double>(begin: 2.0, end: 0.0).animate(_animationControllerEnd)
          ..addListener(() {
            setState(() {
              _scaleFactorEnd = _animationEnd.value;
              Future.delayed(
                  Duration(milliseconds: 900), () => SmartDialog.dismiss());
            });
          });

    _animationController.forward();
  }

  void stop() {
    _animationControllerEnd.forward();
    setState(() {
      ifBig = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: ifBig ? _scaleFactor : _scaleFactorEnd,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.w),
          child: Container(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {

                },
                child: Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.itemBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageUtil.networkImage(
                        url: widget.trophies[index].iconLightImage,
                        width: 36.w,
                        height: 36.h,
                      ),
                      Text(
                        widget.trophies[index].iconName,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                      10.verticalSpace,
                      Text(
                        widget.trophies[index].tips,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 5.sp, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  15.horizontalSpace,
              itemCount: widget.trophies.length,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}
