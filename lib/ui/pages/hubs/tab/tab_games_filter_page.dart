import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../api/index_api.dart';
import '../../../../common/getx_list_controller.dart';
import '../../../../image_utils.dart';
import '../../../../model/beans/games_left_tab_bean.dart';
import '../../../../model/game_model.dart';
import '../../../../widget/image_util.dart';

class TabGamesFilterPage extends StatelessWidget {
  final controller = TabGamesFilterController.find;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Obx(() => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 74.w,
                  margin: EdgeInsets.only(
                    left: 15.w,
                    right: 10.w,
                    top: 3.h,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (c, i) => Obx(() => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => controller.clickLeftTab(i, controller.leftTabs[i].name),
                          child: Container(
                            width: 74.w,
                            height: i != 2 ? 80.h : 90.h,
                            decoration: controller.selectLeftTabIndex.value == i
                                ? ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.59, -0.80),
                                      end: Alignment(-0.59, 0.8),
                                      colors: [
                                        Color(0xFF141414),
                                        Color(0xFF383631),
                                        Color(0xFF141414)
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.w,
                                        color: const Color(0xFFA0998A),
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  )
                                : ShapeDecoration(
                                    color: const Color(0xFF141414),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  controller.leftTabs[i].icon,
                                  width: 30.w,
                                  height: 32.h,
                                ),
                                6.verticalSpace,
                                Text(
                                  controller.leftTabs[i].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    separatorBuilder: (c, i) => 15.verticalSpace,
                    itemCount: controller.leftTabs.length,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: controller.list.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        ImageUtil.networkImage(
                          url: "${controller.list[index].image}",
                          width: 120.w,
                          height: 120.w,
                          fit: BoxFit.cover,
                          border: 8.r,
                        ),
                        10.verticalSpace,
                        Text(
                          '${controller.list[index].name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontFamily: 'DIN',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
                15.horizontalSpace,
              ],
            )),
      );
}

class TabGamesFilterController extends GetxController {
  static TabGamesFilterController get find => Get.find();

  List<GamesLeftTabBean> leftTabs = [
    GamesLeftTabBean(name: "PC".tr, icon: ImageUtils.tab_pc_icon),
    GamesLeftTabBean(name: "Console".tr, icon: ImageUtils.tab_console_icon),
    GamesLeftTabBean(name: "Racing\nsims".tr, icon: ImageUtils.tab_racing_icon),
  ];

  var selectLeftTabIndex = 0.obs;

  List<GameModel> totalList = [];
  var list = <GameItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    totalList = await IndexApi.getGames();
    list.assignAll(totalList.firstWhere((element) => "pc".contains(element.type?.toLowerCase() ?? '')).list);
  }

  void clickLeftTab(int i, String clickTabName) {
    selectLeftTabIndex.value = i;
    list.assignAll(totalList.firstWhere((element) => clickTabName.toLowerCase().contains(element.type?.toLowerCase() ?? '')).list);
  }
}
