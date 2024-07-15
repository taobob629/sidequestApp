import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colorful_button.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/event_detail_model.dart';
import '../../../../utils/utils.dart';
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
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
      child: Row(
        children: [
          Expanded(child: _buildLeftButton()),
          15.horizontalSpace,
          Expanded(child: _buildRightButton())
        ],
      ),
    );
  }

  Widget _buildLeftButton() {
    flog(' eventDetailModel.canCancel');
    return ColorfulButton(
      child: Obx(() => Text(
        eventDetailModel.canCancel ? 'VIEW'.tr : "JOIN TEAM".tr,
        style: TextStyle(
          color: Colors.white,
          fontFamily: FONT_LIGHT,
          fontSize: 18,
        ),
      )),
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
    );
  }

  Widget _buildRightButton() {
    return ClipPath(
      //  clipper: _TrapezoidPath(),
        child: Stack(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFE96524), Color(0xFFD49C21)])),
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
                      eventDetailModel.canCancel ? 'CANCEL'.tr : "MAKE TEAM".tr,
                          style: TextStyle(color: Colors.white, fontFamily: FONT_LIGHT, fontSize: 18),
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
