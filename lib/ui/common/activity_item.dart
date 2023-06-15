import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/model/activity_item_model.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/ui/events/widget/timer_widget.dart';

class ActivityItem extends StatelessWidget {
  final ActivityItemModel model;
  final int type;

  ActivityItem({required this.model, this.type = 1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => EventPage(id: model.id, type: type == 0 ? 0 : 1)),
      // onTap: () => jumpPage(EventPage(id: model.id, type: 1)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: model.inProgress ? Color(0xFF526EEB) : Color(0xFF28253D)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Stack(children: [ AspectRatio(
             aspectRatio: 2 / 1,
             child: ClipRRect(
               borderRadius: BorderRadius.circular(8),
               child: CachedNetworkImage(
                 imageUrl: model.image,
                 fit: BoxFit.cover,
               ),
             ),
           ),
           Positioned(
               right: 10.w,
               bottom: 10.h,
               child: Visibility(
               visible: model.showCounter(),
               child: TimerWidget(DateTime.fromMillisecondsSinceEpoch(model.addtime* 1000)
                   .difference(DateTime.now())
                   .inSeconds)))
           ],),
            SizedBox(
              width: 10,
              height: 15,
            ),
            Row(
              children: [
                Text(
                  model.addtime.toDateStr,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Spacer(),
                Text(
                  "Events".tr,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Container(
                  width: 2,
                  height: 12,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(1), color: Colors.white),
                )
              ],
            ),
            SizedBox(
              width: 10,
              height: 10,
            ),
            Text(
              model.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
