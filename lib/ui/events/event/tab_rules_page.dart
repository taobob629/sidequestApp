import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';

import 'event_page.dart';

class TabRulesPage extends StatelessWidget {
  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
        padding: const EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
        decoration: itemDecoration(),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildContent(),
          );
        }),
      ),
    );
  }

  List<Widget> _buildContent() {
    List<Widget> list = [];
    list.add(Container(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
      child: Stack(
        children: [
          Text(
            "Rules".tr,
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
          ),
        ],
      ),
    ));

    list.add(Html(
      data: controller.eventDetailModel.value.rules,
      style: {
        "body": Style(
          color: Colors.white60,
        )
      },
    ));
    return list;
  }
}
