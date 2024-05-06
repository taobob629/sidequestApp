import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../api/wy_http.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../../../model/tab_cybercafe_model.dart';
import '../../../utils/permission_helper.dart';
import '../booking/booking_detail_page.dart';

class TabCybercafePage extends StatelessWidget {
  final _ctr = Get.put(CybercafeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          title: const Text("Flutter 留着状态栏高度，去掉appbar高度"),
        ),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: _ctr.refreshController,
          onLoading: () => _ctr.loadMore(),
          onRefresh: () => _ctr.onRefresh(),
          enablePullUp: true,
          child: ListView.separated(
            itemCount: _ctr.list.length,
            itemBuilder: (context, index) {
              final model = _ctr.list[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    Get.to(() => BookingDetailPage(), arguments: model.id),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Stack(
                    children: [
                      20.verticalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Image.network(
                          model.headImage,
                          height: 180.h,
                          width: Get.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      15.verticalSpace,
                      Container(
                        margin: EdgeInsets.only(left: 30.w, top: 100.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Text(
                              model.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            10.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.w,
                                  color: AppColor.yellow,
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              padding: EdgeInsets.only(right: 4.w),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.yellow,
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Text(
                                      'In business'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FONT_MEDIUM,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    model.openTime,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: FONT_MEDIUM,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                15.verticalSpace,
          ),
        ),
      ),
    );
  }
}

class CybercafeController extends GetxRefreshController<TabCyberCafeModel> {
  static CybercafeController get find => Get.find();

  @override
  Future<List<TabCyberCafeModel>> loadData({int pageNum = 1}) async {
    showLoading();
    List<TabCyberCafeModel> list = [];
    var response = await http.get('/app/store/cybercafe/booking/newStores',
        queryParameters: ({
          'pageNum': pageNum,
          'pageSize': pageSize,
        }));
    dismissLoading();
    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<TabCyberCafeModel>((item) => TabCyberCafeModel.fromJson(item))
        .toList();
    return list;
  }
}
