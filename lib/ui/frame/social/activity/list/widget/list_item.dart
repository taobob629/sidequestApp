/**
    author:mac
    创建日期:2023/2/24
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/activity_list_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:wy/ui/events/widget/timer_widget.dart';
import 'package:wy/utils/index.dart';

class ActivityListItemWidget extends StatelessWidget {
  late ActivityListModel model;

  ActivityListItemWidget(this.model);

  var imageSize = 30.h;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => EventPage(id: model.id, type: model.matchDiff)),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10.h).w,
        height: 270.h,
        decoration: itemDecoration(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                top: 0,
                child: Container(
                  height: 200.h,
                  width: Get.width - 30.w,
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(16.0)),
                    image: new DecorationImage(
                      image: NetworkImage(model.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Positioned(
                bottom: 5.h,
                left: 12.5.w,
                right: 12.5.w,
                child: Container(
                  padding: EdgeInsets.only(left: 15.r, right: 15.r),
                  alignment: Alignment.centerLeft,
                  //    color: Colors.grey.withOpacity(0.1),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${model.title}\n',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        TextSpan(
                            text: '${model.datetime.toDateStr}',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM,
                            )),
                      ],
                    ),
                    textAlign: TextAlign.start,
                    strutStyle: StrutStyle(height: 1.7),
                  ),
                )),
            Positioned(
                top: 200.h - imageSize / 2,
                left: 15.w,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: Get.width, maxHeight: imageSize + 10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: buildPartener(model),
                  ),
                )),
            Positioned(
                right: 20.w,
                bottom: 12.h,
                child: InkWell(
                  onTap: () => Get.to(
                    () => EventPage(
                      id: model.id,
                      type: model.matchDiff,
                    ),
                  ),
                  child: ImageUtil.assetImage(
                    'arrow_more',
                    width: 42.w,
                    height: 42.w,
                  ),
                )),
            Positioned(
              right: 16,
              bottom: 50.h,
              child: Visibility(
                visible: model.showCounter(),
                child: TimerWidget(
                  DateTime.fromMillisecondsSinceEpoch(model.datetime * 1000)
                      .difference(DateTime.now())
                      .inSeconds,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildPartener(ActivityListModel model) {
    var index = 0;
    return model.showParticipants().map((item) {
      index += 1;
      return Positioned(
          bottom: 0,
          top: 0,
          left: (index - 1) * imageSize * 3 / 4,
          child: Container(
            child: ImageUtil.networkImage(
                fit: BoxFit.cover,
                url: item.photo,
                width: imageSize,
                height: imageSize,
                border: imageSize / 2),
          ));
    }).toList();
  }
}
