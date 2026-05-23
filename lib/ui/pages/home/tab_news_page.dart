import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/common/base_scaffold.dart';

import '../../../api/index_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../config/icon_font.dart';
import '../../../model/banner_model.dart';
import '../../../model/news_item_model.dart';
import '../../../model/tab_news_model.dart';
import '../../../widget/banner_view.dart';
import '../../../widget/image_util.dart';
import '../../../widget/news_item.dart';
import 'news_page.dart';

class TabNewsPage extends StatelessWidget {
  final controller = TabNewsPageController.find;

  @override
  Widget build(BuildContext context) => BaseScaffold(
    title: 'News'.tr,
    body: Column(
          children: [
            Obx(() => SizedBox(
                  height: 200.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, i) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.to(
                        () => NewsPage(
                          id: controller.headLineList[i].id,
                        ),
                        transition: Transition.noTransition,
                      ),
                      child: Container(
                        width: 253.w,
                        height: 200.h,
                        margin: EdgeInsets.only(left: i == 0 ? 16.w : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Stack(
                          children: [
                            ImageUtil.networkImage(
                              url: '${controller.headLineList[i].image}',
                              width: 253.w,
                              height: 200.h,
                              border: 16.r,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: 253.w,
                              height: 200.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Text(
                                    '${controller.headLineList[i].title}',
                                    style: TextStyle(
                                      fontFamily: FONT_MEDIUM,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                10.verticalSpace,
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    bottom: 16.h,
                                  ),
                                  child: Text(
                                    '${controller.headLineList[i].createTime}',
                                    style: TextStyle(
                                      fontFamily: FONT_LIGHT,
                                      fontSize: 12.sp,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (c, i) => 15.horizontalSpace,
                    itemCount: controller.headLineList.length,
                  ),
                )),
            15.verticalSpace,
            Expanded(
              child: Obx(() => SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    onLoading: controller.loadMore,
                    enablePullUp: true,
                    enablePullDown: true,
                    child: ListView.separated(
                      itemBuilder: (c, i) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.to(
                          () => NewsPage(
                            id: controller.list[i].id,
                          ),
                          transition: Transition.noTransition,
                        ),
                        child: SizedBox(
                          height: 112.h,
                          child: Row(
                            children: [
                              16.horizontalSpace,
                              if (controller.list[i].imageList.isNotEmpty)
                                ImageUtil.networkImage(
                                  url: controller.list[i].imageList[0],
                                  border: 16.r,
                                  width: 112.w,
                                  height: 82.h,
                                  fit: BoxFit.cover,
                                ),
                              10.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${controller.list[i].title}',
                                      style: TextStyle(
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    10.verticalSpace,
                                    Text(
                                      '${controller.list[i].time}',
                                      style: TextStyle(
                                        fontFamily: FONT_LIGHT,
                                        fontSize: 12.sp,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (c, i) => 0.verticalSpace,
                      itemCount: controller.list.length,
                    ),
                  )),
            ),
          ],
        ),
  );
}

class TabNewsPageController extends GetxRefreshController<TabNewsListElement> {
  static TabNewsPageController get find => Get.find();

  var headLineList = <Headline>[].obs;

  @override
  void onInit() {
    super.onInit();
    pageSize = 10;
  }

  @override
  Future<List<TabNewsListElement>> loadData(
      {int pageNum = GetxRefreshController.pageNumFirst}) async {
    TabNewsModel model = await IndexApi.getNews(pageNum, pageSize);
    headLineList.assignAll(model.headline);
    return model.list;
  }
}
