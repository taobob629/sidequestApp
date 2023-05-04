import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/ui/booking/booking_detail_page.dart';

import '../../api/wy_http.dart';
import '../../common/getx_refresh_controller.dart';
import '../../config/icon_font.dart';
import '../../model/tab_cybercafe_model.dart';
import '../../utils/image_util.dart';

class TabCybercafePage extends StatelessWidget {
  final _ctr = Get.put(CybercafeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SmartRefresher(
        controller: _ctr.refreshController,
        onLoading: () => _ctr.loadMore(),
        onRefresh: () => _ctr.onRefresh(),
        enablePullUp: true,
        child: ListView.builder(
            itemCount: _ctr.list.length,
            itemBuilder: (context, index) {
              final model = _ctr.list[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    Get.to(() => BookingDetailPage(), arguments: model.id),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: ImageUtil.networkImage(
                          url: model.headImage,
                          height: 180.h,
                          width: Get.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      15.verticalSpace,
                      Text(
                        model.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          Text(
                            'In business'.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM,
                              color: Color(0xffFFD20E),
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            model.openTime,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM,
                              color: Color(0xff808388),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Transform.translate(
                        offset: Offset(-4.w, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            Expanded(
                              child: Text(
                                model.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })));
  }
}

class CybercafeController extends GetxRefreshController<TabCyberCafeModel> {
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
    var response = await http.get('/app/store/cybercafe/booking/stores',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<TabCyberCafeModel>((item) => TabCyberCafeModel.fromJson(item))
        .toList();
    return list;
  }
}
