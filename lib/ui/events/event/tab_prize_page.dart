import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'event_page.dart';

class TabPrizePage extends StatelessWidget {

  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
        padding: const EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
        decoration: BoxDecoration(
          color: Color(0xCC28253D),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildPrizeContent(),
          );
        }),
      ),
    );
  }

  List<Widget> _buildPrizeContent() {
    List<Widget> list = [];

    list.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text("Prizes", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),)
            ),
          ],
        ),
      )
    );

    list.add(Html(
      data: controller.eventDetailModel.value.prizes,
      style: {
        "body": Style(color: Colors.white54,lineHeight: LineHeight(2))
      },
    ));
    return list;
  }
}