import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/styles.dart';
import '../../../../config/icon_font.dart';
import '../../../../model/participant_model.dart';
import 'event_page.dart';

class TabParticipantsPage extends StatelessWidget {
  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        decoration: itemDecoration(),
        child: Obx(() {
          return Column(
            children: _buildRows(),
          );
        }),
      ),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    rows.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Stack(
        children: [
          Text(
            "Participants".tr,
            style: TextStyle(
                color: Colors.white, fontSize: 15.sp, fontFamily: FONT_MEDIUM),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${controller.eventDetailModel.value.participantes()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM),
              ))
        ],
      ),
    ));
    var list = controller.eventDetailModel.value.participants;
    int size = list.length % 3 > 0 ? list.length ~/ 3 + 1 : list.length ~/ 3;
    for (int line = 0; line < size; line++) {
      List<Widget> children = [];
      for (int index = 0; index < 3; index++) {
        int id = line * 3 + index;
        if (id < list.length) {
          children.add(_buildItem(list[id]));
        } else {
          children.add(Container(
            width: 100,
          ));
        }
      }
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      );
      rows.add(row);
    }
    return rows;
  }

  Widget _buildItem(ParticipantModel model) {
    var imageSize = 60.w;
    return Expanded(
      //width: itemSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Offstage(
              offstage: controller.type == 1,
              child: Text(
                "${'Ranking'.tr}:${model.getRank()}",
                style: TextStyle(color: Colors.white, fontSize: 12),
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(imageSize / 2),
            child: CachedNetworkImage(
              imageUrl: model.avatar,
              width: imageSize,
              height: imageSize,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15, top: 4.h),
            child: Text(
              model.name,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, fontSize: 14.sp, fontFamily: FONT_LIGHT),
            ),
          )
        ],
      ),
    );
  }
}
