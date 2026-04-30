import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';

import '../../../../api/index_api.dart';
import '../../../../common/empty_view.dart';
import '../../../../image_utils.dart';
import '../../../../model/beans/games_left_tab_bean.dart';
import '../../../../model/game_model.dart';
import '../../../../widget/image_util.dart';
import '../../../dialog/dialog_support_stores.dart';

class TabGamesFilterPage extends StatelessWidget {
  final controller = TabGamesFilterController.find;

  @override
  Widget build(BuildContext context) => Obx(() => Container(
        width: 1.sw,
        child: controller.list.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: controller.list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 6 / 9,
                ),
                itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () => Get.dialog(
                      DialogSupportStores(controller.list[index].stores,controller.list[index].platforms,
                          image: controller.list[index].image)),
                  child: Column(
                    children: [
                      Container(
                        width: (90 * 6 / 9).h,
                        height: 90.h,
                        decoration: BoxDecoration(
                          color: hexColor("222222"),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: ImageUtil.networkImage(
                            url: "${controller.list[index].image}",
                            width: (90 * 6 / 9).h,
                            height: 90.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        '${controller.list[index].name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontFamily: 'DIN',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: EmptyView(),
              ),
      ));
}

class TabGamesFilterController extends GetxController {
  static TabGamesFilterController get find => Get.find();

  var list = <GameItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    List<GameModel> totalList = await IndexApi.getGames();
    // 合并所有游戏数据
    List<GameItemModel> allGames = [];
    for (var gameModel in totalList) {
      allGames.addAll(gameModel.list);
    }
    list.assignAll(allGames);
  }
}
