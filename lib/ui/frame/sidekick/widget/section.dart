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

class SectionWidget extends StatelessWidget {
  GlobalKey _stackKey = GlobalKey();
  final Widget listBody;
  SideKickController controller = Get.find<SideKickController>();

  SectionWidget({required this.listBody});

  @override
  Widget build(BuildContext context) {
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
                  Expanded(child: Container(child: listBody)),
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
                dividerColor: Colors.transparent,
                itemDecoration: BoxDecoration(
                    color: Color(0xff32353D), borderRadius: BorderRadius.circular(5.w)),
                color: Color(0xFF1B1A1E),
              //  height: 30.h,
                borderColor: Colors.transparent,
                items: controller.filters
                    .map((item) => GZXDropDownHeaderItem(item?.name ?? '',
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
            dropDownWidget: Obx(() => languageSection(context)),
            dropDownHeight: lengthLength * sectionHeight),
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => genderSection(context)),
            dropDownHeight: genderLength * sectionHeight),
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => levelSection(context)),
            dropDownHeight: levelLength * sectionHeight),
        GZXDropdownMenuBuilder(
            dropDownWidget: Obx(() => gameLevelSection(context)),
            dropDownHeight: gameLength * sectionHeight),
      ],
    );
  }

  MediaQuery languageSection(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.onSectionChange(0, index);
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.language[index].name}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.language?.length ?? 0,
        ));
  }

  MediaQuery genderSection(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.onSectionChange(1, index);
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.genders[index].name}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.genders?.length ?? 0,
        ));
  }

  MediaQuery levelSection(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.onSectionChange(2, index);
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.levels[index].name}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.levels?.length ?? 0,
        ));
  }

  MediaQuery gameLevelSection(context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              controller.onSectionChange(3, index);
              dropDownController.hide();
            },
            child: Container(
              height: sectionHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10).r,
              child: Text(
                '${controller.gameSections?.gameLevel[index].name}',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
            ),
          ),
          itemCount: controller.gameSections?.gameLevel?.length ?? 0,
        ));
  }
}
