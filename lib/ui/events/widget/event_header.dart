import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/event_detail_model.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:wy/ui/events/widget/timer_widget.dart';
import 'package:wy/utils/index.dart';

class EventFlexibleHeader extends GetView<EventPageController> {
  final String image;

  EventFlexibleHeader({required this.image});

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        background: Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColor.background])),
            )),
        Positioned(
            right: 16,
            bottom: 50.h,
            child: Obx(() => Visibility(
                visible:
                    controller.eventDetailModel.value.showCounter(),
                child: TimerWidget(DateTime.fromMillisecondsSinceEpoch(
                        controller.eventDetailModel.value.kopStartTime * 1000)
                    .difference(DateTime.now())
                    .inSeconds))))
      ],
    ));
  }
}
