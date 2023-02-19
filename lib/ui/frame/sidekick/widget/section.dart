/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/drop_down/gzx_dropdown_menu.dart';

List gameFilter = ['语言', '性别', '等级', '段位'];

class SectionWidget extends StatelessWidget {
  GlobalKey _stackKey = GlobalKey();
  final Widget listBody;
  SideKickController controller = Get.find<SideKickController>();

  SectionWidget({required this.listBody});

  @override
  Widget build(BuildContext context) {
    flog('buildbuildbuild');
    return Obx(() => Visibility(
        visible: controller.gameList.isNotEmpty && controller.gameSections != null,
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15).r,
          child: Stack(
            key: _stackKey,
            children: [
              Column(
                children: [
                  buildDropdownHeader(),
                  Expanded(child: listBody),
                ],
              ),
              buildDropdownMenu(context)
            ],
          ),
        )));
  }

  var dropDownController = GZXDropdownMenuController();

  Widget buildDropdownHeader() {
    return MediaQuery.removePadding(
        context: Get.context!,
        removeTop: true,
        child: Container(
          child: Obx(() => GZXDropDownHeader(
                iconColor: Colors.white,
                dropDownStyle: TextStyle(color: AppColor.textYellow, fontSize: 12.sp),
                iconDropDownColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
                itemDecoration: BoxDecoration(
                    color: Color(0xff32353D), borderRadius: BorderRadius.circular(5.w)),
                color: Color(0xFF1B1A1E),
                height: 30.h,
                borderColor: Colors.transparent,
                items: controller.filters
                    .map((str) => GZXDropDownHeaderItem(str,
                        iconData: Icons.keyboard_arrow_down_rounded,
                        iconDropDownData: Icons.keyboard_arrow_up))
                    .toList(),
                dividerHeight: 1,
                //  style: TextStyle(color: Colors.white),
                controller: dropDownController,
                stackKey: _stackKey,
                onItemTap: (item) {
                  //   controller.show(1);
                },

                ///特殊模块,选中数据只亮起,不需要更改头部title,下标为1
              )),
        ));
  }

  var sectionHeight = 40.h;

  buildDropdownMenu(context) {
    int lengthLength = controller.gameSections?.language.length ?? 1;
    int genderLength = controller.gameSections?.genders.length ?? 1;
    int levelLength = controller.gameSections?.levels.length ?? 1;
    int gameLength = controller.gameSections?.gameLevel.length ?? 1;
    return GZXDropDownMenu(
      decoration: BoxDecoration(color: Color(0xff32353D), borderRadius: BorderRadius.circular(5.w)),
      controller: dropDownController,
      menus: [
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => languageSecion(context)),
            dropDownHeight: lengthLength * sectionHeight),
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => genderSecion(context)),
            dropDownHeight: genderLength * sectionHeight),
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => levelSecion(context)),
            dropDownHeight: levelLength * sectionHeight),
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => gameLevelSecion(context)),
            dropDownHeight: gameLength * sectionHeight),
      ],
    );
  }

  MediaQuery languageSecion(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.filters[0] = controller.gameSections?.language[index];
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.language[index]}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.language?.length ?? 0,
        ));
  }

  MediaQuery genderSecion(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.filters[1] = controller.gameSections?.genders[index];
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.genders[index]}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.genders?.length ?? 0,
        ));
  }

  MediaQuery levelSecion(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.filters[2] = controller.gameSections?.levels[index];
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.levels[index]}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.levels?.length ?? 0,
        ));
  }

  MediaQuery gameLevelSecion(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.filters[3] = controller.gameSections?.gameLevel[index];
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.gameLevel[index]}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.gameLevel?.length ?? 0,
        ));
  }
}
