import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:sq_hub_app/common/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../config/icon_font.dart';
import '../../../../../model/event_detail_model.dart';
import '../../../../../widget/paixs_widget.dart';
import '../../../../common/styles.dart';
import '../../events/event/event_page.dart';

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
          decoration: itemDecoration(),
          child: Column(
            children:controller.eventDetailModel.value.matchDiff==TYPE_PRIZE?[
              _buildSectionTopItem(
                "time".tr,
                "Draw Time".tr,
                "${controller.eventDetailModel.value.start.toDateStr}",
              ),
              _buildSectionTopItem(
                "people".tr,
                "Participants".tr,
                "${controller.eventDetailModel.value.participantNum}",
              ),
              _buildSectionTopItem(
                "fee".tr,
                "Price".tr,
                "${controller.eventDetailModel.value.fee}",
              ),
              _buildSectionTopItem(
                "day".tr,
                "Constraint".tr,
                "${controller.eventDetailModel.value.constraint}",
              ),
              _buildSectionTopItem(
                "day".tr,
                "Formation".tr,
                "${controller.eventDetailModel.value.formation}",
              ),
            ]: [
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
                "time".tr,
                "Start Time".tr,
                "${controller.eventDetailModel.value.start.toDateStr}",
              ),
              controller.type == 0
                  ? _buildSectionTopItem(
                      "time".tr, "Check In".tr, "${controller.eventDetailModel.value.checkin.toDateStr}")
                  : Container(),
              _buildSectionTopItem(
                "fee".tr,
                "Price".tr,
                "£ ${controller.eventDetailModel.value.fee}",
                align: CrossAxisAlignment.start,
              ),
              _buildSectionTopItem(
                "day".tr,
                "Constraint".tr,
                "${controller.eventDetailModel.value.constraint}",
              ),
              _buildSectionTopItem(
                "day".tr,
                "Formation".tr,
                "${controller.eventDetailModel.value.formation}",
              ),
              controller.type == 0
                  ? _buildSectionTopItem(
                      "game".tr, "Game".tr, "${controller.eventDetailModel.value.gameName}")
                  : Container(),
              // _buildSectionTopItem("people", "Participants", "${controller.eventDetailModel.value.participants.length}/${controller.eventDetailModel.value.totalMembers}"),
              // controller.type == 0 ? _buildSectionTopItem("device", "Equipment", "${controller.eventDetailModel.value.equipment}") : Container(),
              // _buildSectionTopItem(
              //   "fee",
              //   "Price",
              //   "£ ${controller.eventDetailModel.value.fee}",
              //   align: CrossAxisAlignment.start,
              // ),
              _buildSectionTopItem(
                "online".tr,
                "Location&Participants".tr,
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

  Color iconColor = Color(0xff808388);

  Widget _buildSectionTopItem(String iconName, String title, String content,
      {CrossAxisAlignment align = CrossAxisAlignment.center,
      double width = 20,
      double height = 20}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      child: PWidget.column([
        Row(
          crossAxisAlignment: align,
          children: [
            SvgPicture.asset(
              "assets/images/ic_match_o_$iconName.svg",
              color: iconColor,
              width: width,
              height: height,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4),
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontFamily: FONT_MEDIUM, fontSize: 16),
              ),
            ),
            if (!title.contains('Location'.tr))
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: align == CrossAxisAlignment.start ? 6 : 0),
                  child: Text(
                    content,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: iconColor, fontSize: 12, fontFamily: FONT_MEDIUM, height: 1.5),
                  ),
                ),
              )
          ],
        ),
        if (title.contains('Location'.tr))
          Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(color: iconColor, fontFamily: FONT_MEDIUM, fontSize: 12, height: 1.5),
          ),
      ], '111'),
    );
  }

  Widget _buildSectionBottom() {
    return Obx(() => Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: itemDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "GENERAL INFORMATION".tr,
                style: TextStyle(color: Colors.white, fontFamily: FONT_MEDIUM, fontSize: 16.sp),
              ),
            ),
            Html(
              data: controller.eventDetailModel.value.generalInfo,
              style: {"body": Style(color: Colors.white54, lineHeight: LineHeight(2),fontFamily: FONT_MEDIUM)},
              onLinkTap: (String? url, RenderContext context, Map<String, String> attributes,
                  dom.Element? element) async {
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
