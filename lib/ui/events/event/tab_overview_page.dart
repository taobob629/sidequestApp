import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:html/dom.dart' as dom;

import '../../../widget/paixs_widget.dart';

class TabOverviewPage extends StatelessWidget {
  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionTop(),
          _buildSectionBottom(),
          Container(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _buildSectionTop() {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(color: Color(0xCC28253D), borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              // _buildSectionTopItem("time", "Check In", "${controller.eventDetailModel.value.checkinTime}"),
              // _buildSectionTopItem("day", "Event Time", "${controller.eventDetailModel.value.startTime}"),
              // controller.type == 2 ? _buildSectionTopItem("game", "Game", "${controller.eventDetailModel.value.gameName}") : Container(),
              // _buildSectionTopItem("people", "Participants", "${controller.eventDetailModel.value.participants.length}/${controller.eventDetailModel.value.totalMembers}"),
              // controller.type == 2 ? _buildSectionTopItem("device", "Equipment", "${controller.eventDetailModel.value.equipment}") : Container(),
              // _buildSectionTopItem(
              //   "fee",
              //   "Price",
              //   "£ ${controller.eventDetailModel.value.fee}",
              //   align: CrossAxisAlignment.start,
              // ),
              // _buildSectionTopItem("online", "Location", "${controller.eventDetailModel.value.getLocationList()}", align: CrossAxisAlignment.start),
              _buildSectionTopItem(
                "time",
                "Start Time",
                "${controller.eventDetailModel.value.startTime}",
              ),
              controller.type == 0 ? _buildSectionTopItem("time", "Check In", "${controller.eventDetailModel.value.checkinTime}") : Container(),
              _buildSectionTopItem(
                "fee",
                "Price",
                "£ ${controller.eventDetailModel.value.fee}",
                align: CrossAxisAlignment.start,
              ),
              _buildSectionTopItem(
                "day",
                "Constraint",
                "${controller.eventDetailModel.value.constraint}",
              ),
              _buildSectionTopItem(
                "day",
                "Formation",
                "${controller.eventDetailModel.value.formation}",
              ),
              controller.type == 0 ? _buildSectionTopItem("game", "Game", "${controller.eventDetailModel.value.gameName}") : Container(),
              // _buildSectionTopItem("people", "Participants", "${controller.eventDetailModel.value.participants.length}/${controller.eventDetailModel.value.totalMembers}"),
              // controller.type == 0 ? _buildSectionTopItem("device", "Equipment", "${controller.eventDetailModel.value.equipment}") : Container(),
              // _buildSectionTopItem(
              //   "fee",
              //   "Price",
              //   "£ ${controller.eventDetailModel.value.fee}",
              //   align: CrossAxisAlignment.start,
              // ),
              _buildSectionTopItem(
                "online",
                "Location&Participants",
                List.generate(controller.eventDetailModel.value.location.length, (i) {
                  var locationModel = controller.eventDetailModel.value.location[i];
                  // return '\n${locationModel.name}\t\t${locationModel.join}/${locationModel.total}';
                  return '${locationModel.name}';
                }).join('\n'),
                align: CrossAxisAlignment.start,
              ),
            ],
          ),
        ));
  }

  Widget _buildSectionTopItem(String iconName, String title, String content, {CrossAxisAlignment align = CrossAxisAlignment.center, double width = 20, double height = 20}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      child: PWidget.column([
        Row(
          crossAxisAlignment: align,
          children: [
            SvgPicture.asset(
              "assets/images/ic_match_o_$iconName.svg",
              color: Color(0xFF7D8AAC),
              width: width,
              height: height,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4),
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 16),
              ),
            ),
            if (!title.contains('Location'))
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: align == CrossAxisAlignment.start ? 6 : 0),
                  child: Text(
                    content,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Color(0xFF7C8AAD), fontSize: 12, height: 1.5),
                  ),
                ),
              )
          ],
        ),
        if (title.contains('Location'))
          Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(color: Color(0xFF7C8AAD), fontSize: 12, height: 1.5),
          ),
      ], '111'),
    );
  }

  Widget _buildSectionBottom() {
    return Obx(() => Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(color: Color(0xCC28253D), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "GENERAL INFORMATION",
                style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 16),
              ),
            ),
            Html(
              data: controller.eventDetailModel.value.generalInfo,
              style: {"body": Style(color: Colors.white54, lineHeight: LineHeight(2))},
              onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) async {
                if (url != null) {
                  await launch(url);
                }
              },
            )
          ],
        )));
  }
}

class MatchInfo {}
