import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/event_detail_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/utils.dart';

import 'event_page.dart';
import 'join_team_page.dart';

class JoinButton extends GetView<EventPageController> {
  late final EventDetailModel eventDetailModel;

  final userController = Get.find<UserController>();
  final EventPageController eventPageController =
      Get.find<EventPageController>();

  JoinButton({required this.eventDetailModel});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 30;
    return Container(
      height: 50,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: width / 2 + 10,
              child: _buildLeftButton()),
          Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: width / 2 + 10,
              child: _buildRightButton())
        ],
      ),
    );
  }

  Widget _buildLeftButton() {
    flog(' eventDetailModel.canCancel');
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Obx(() => Text(
                  eventDetailModel.canCancel ? 'VIEW MY TEAM' : "JOIN TEAM",
                  style: TextStyle(
                      color: Color(0xFFF73B0C),
                      fontFamily: "DIN",
                      fontSize: 20),
                )),
          )),
        ),
        Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
                onTap: () =>
                    userController.checkLogin(() => eventDetailModel.canCancel
                        ? controller.viewTeam()
                        : Get.to(() => JoinTeamPage(
                              id: eventDetailModel.id,
                              create: false,
                              banner: eventDetailModel.listImage.isEmpty
                                  ? eventDetailModel.image
                                  : eventDetailModel.listImage,
                              location: [],
                            ))),
                child: Container()),
          ),
        )
      ],
    );
  }

  Widget _buildRightButton() {
    return ClipPath(
        clipper: _TrapezoidPath(),
        child: Stack(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFC3C02), Color(0xFF841FC3)]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!eventDetailModel.canCancel)
                    Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Obx(() => Text(
                          eventDetailModel.canCancel ? 'CANCEL' : "MAKE TEAM",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "DIN",
                              fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Ink(
                child: InkWell(
                    onTap: () => userController.checkLogin(() =>
                        eventDetailModel.canCancel
                            ? controller.cancelActivity()
                            : eventPageController
                                .checkFee(() => Get.to(() => JoinTeamPage(
                                      id: eventDetailModel.id,
                                      create: true,
                                      banner: eventDetailModel.image,
                                      location: eventDetailModel.location,
                                    )))),
                    child: Container()),
              ),
            )
          ],
        ));
  }
}

class _TrapezoidPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 50); //x,y坐标
    path.lineTo(10, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
