import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/participant_model.dart';

import 'event_page.dart';

class TabParticipantsPage extends StatelessWidget {

  final controller = Get.find<EventPageController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        decoration: BoxDecoration(
          color: Color(0xCC28253D),
          borderRadius: BorderRadius.circular(16)
        ),
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
    rows.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text("Participants", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),)
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${controller.eventDetailModel.value.participants.length}/${controller.eventDetailModel.value.totalMembers}",
                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
              )
            )
          ],
        ),
      )
    );
    var list = controller.eventDetailModel.value.participants;
    int size = list.length % 3 > 0 ? list.length ~/ 3 + 1 : list.length ~/ 3;
    for (int line = 0; line < size; line++) {
      List<Widget> children = [];
      for (int index = 0; index < 3; index++) {
        int id = line * 3 + index;
        if (id < list.length) {
          children.add(_buildItem(list[id]));
        } else {
          children.add(Container(width: 100,));
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
    return Container(
      width: 100,
      child: Column(
        children: [
          Offstage(
            offstage: controller.type == 1,
            child: Text("Ranking:${model.getRank()}", style: TextStyle(color: Colors.white, fontSize: 12),)
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 5),
            child: AspectRatio(
              aspectRatio: 1,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: model.avatar,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(model.name, style: TextStyle(color: Colors.white, fontSize: 14),),
          )
        ],
      ),
    );
  }
}