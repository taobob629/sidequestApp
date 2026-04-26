import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../api/wy_http.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../config/icon_font.dart';
import '../../../model/tab_cybercafe_model.dart';
import '../../../widget/image_util.dart';
import '../booking/booking_detail_page.dart';

class TabCybercafePage extends StatelessWidget {
  CybercafeController get _ctr {
    // 确保控制器已经注册
    if (!Get.isRegistered<CybercafeController>()) {
      Get.put(CybercafeController());
    }
    return Get.find<CybercafeController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SmartRefresher(
      controller: _ctr.refreshController,
      onLoading: () => _ctr.loadMore(),
      onRefresh: () => _ctr.onRefresh(),
      enablePullUp: true,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: _ctr.list.length,
        separatorBuilder: (BuildContext context, int index) =>
        16.verticalSpace,
        itemBuilder: (context, index) {
          final model = _ctr.list[index];
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () =>
                Get.to(() => BookingDetailPage(), arguments: model.id),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        child: ImageUtil.networkImage(
                          url: model.headImage,
                          height: 180.h,
                          width: Get.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        top: -8.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFB20E), Color(0xFFFF9500)],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            model.shortName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontFamily: ZEN_DOTS,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                model.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white.withOpacity(0.6),
                              size: 20.sp,
                            ),
                          ],
                        ),
                        12.verticalSpace,
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10b981),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'In operation'.tr,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            16.horizontalSpace,
                            Text(
                              model.openTime,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: FONT_MEDIUM,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white.withOpacity(0.6),
                              size: 15.sp,
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: Text(
                                model.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Colors.white.withOpacity(0.6),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

class CybercafeController extends GetxRefreshController<TabCyberCafeModel> {
  static CybercafeController get find => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<List<TabCyberCafeModel>> loadData({int pageNum = 1}) async {
    List<TabCyberCafeModel> list = [];
    var response = await http.get('/sideQuest/app/stores/storesList',
        queryParameters: ({
          'pageNum': pageNum,
          'pageSize': pageSize,
        }));
    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<TabCyberCafeModel>((item) => TabCyberCafeModel.fromJson(item))
        .toList();
    return list;
  }
}