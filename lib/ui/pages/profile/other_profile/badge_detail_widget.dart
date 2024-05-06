import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/app_color.dart';
import '../../../../event_bus/beans/badge_event.dart';
import '../../../../event_bus/event_bus.dart';
import '../../../../model/profile_model.dart';
import '../../../../utils/toast_utils.dart';

class BadgeDetailWidget extends StatefulWidget {
  TrophieModel trophies;

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
        Tween<double>(begin: 1.0, end: 2.5).animate(_animationController)
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
        Tween<double>(begin: 2.5, end: 0.0).animate(_animationControllerEnd)
          ..addListener(() {
            setState(() {
              _scaleFactorEnd = _animationEnd.value;
              Future.delayed(
                  Duration(milliseconds: 900), () => dismissLoading());
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
            height: 110.w,
            width: 110.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.itemBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.trophies.iconLightImage,
                  width: 40.w,
                  height: 40.h,
                ),
                Text(
                  widget.trophies.iconName,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
                10.verticalSpace,
                Text(
                  widget.trophies.tips,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8.sp, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
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
