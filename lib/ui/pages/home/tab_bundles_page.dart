import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../api/index_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../config/icon_font.dart';
import '../../../model/banner_model.dart';
import '../../../model/bundles_model.dart';
import '../../../model/news_item_model.dart';
import '../../../model/tab_news_model.dart';
import '../../../widget/banner_view.dart';
import '../../../widget/image_util.dart';
import '../../../widget/news_item.dart';
import 'bundles_detail_page.dart';
import 'news_page.dart';

class TabBundlesPage extends StatelessWidget {
  final controller = TabBundlesPageController.find;

  @override
  Widget build(BuildContext context) => Obx(() => SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        onLoading: controller.loadMore,
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.separated(
          itemBuilder: (c, i) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.to(() => BundlesDetailPage(), arguments: controller.list[i].id),
            child: Container(
              height: 112.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: ShapeDecoration(
                color: const Color(0xFF141517),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  16.horizontalSpace,
                  ImageUtil.networkImage(
                    url: '${controller.list[i].image}',
                    border: 10.r,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${controller.list[i].name}',
                          style: TextStyle(
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.verticalSpace,
                        Text(
                          controller.list[i].brief ?? '',
                          style: TextStyle(
                            fontFamily: FONT_LIGHT,
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.verticalSpace,
                        Text(
                          '£${controller.list[i].price}',
                          style: TextStyle(
                            color: const Color(0xFFFFB20E),
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                      top: 40.h,
                    ),
                    child: Image.asset(
                      ImageUtils.bundles_cart_icon,
                      scale: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          separatorBuilder: (c, i) => 10.verticalSpace,
          itemCount: controller.list.length,
        ),
      ));
}

class TabBundlesPageController extends GetxRefreshController<BundlesModel> {
  static TabBundlesPageController get find => Get.find();

  @override
  Future<List<BundlesModel>> loadData(
      {int pageNum = GetxRefreshController.pageNumFirst}) async {
    List<BundlesModel> list = await IndexApi.getBundles();
    return list;
  }
}
