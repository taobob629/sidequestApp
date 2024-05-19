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
  final _ctr = Get.put(CybercafeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          title: Text("Flutter 留着状态栏高度，去掉appbar高度"),
        ),
      ),
      body: Obx(() => SmartRefresher(
            controller: _ctr.refreshController,
            onLoading: () => _ctr.loadMore(),
            onRefresh: () => _ctr.onRefresh(),
            enablePullUp: true,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _ctr.list.length,
              separatorBuilder: (BuildContext context, int index) =>
                  20.verticalSpace,
              itemBuilder: (context, index) {
                final model = _ctr.list[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      Get.to(() => BookingDetailPage(), arguments: model.id),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 320.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Color(0xFF141414),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16.r),
                                    topLeft: Radius.circular(16.r),
                                  ),
                                  child: ImageUtil.networkImage(
                                    url: model.headImage,
                                    height: 180.h,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                15.verticalSpace,
                                Row(
                                  children: [
                                    16.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        model.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: FONT_MEDIUM,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    16.horizontalSpace,
                                  ],
                                ),
                                10.verticalSpace,
                                Row(
                                  children: [
                                    16.horizontalSpace,
                                    Text(
                                      'In operation'.tr,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FONT_MEDIUM,
                                        color: Color(0xff32BE48),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      model.openTime,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FONT_MEDIUM,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                10.verticalSpace,
                                Transform.translate(
                                  offset: Offset(-4.w, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      14.horizontalSpace,
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 18.sp,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 36.h,
                                          child: Text(
                                            model.address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: FONT_MEDIUM,
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16.w,
                          top: 0,
                          child: Container(
                            width: 46.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  ImageUtils.store_ranking_icon,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10.h),
                            alignment: Alignment.topCenter,
                            child: Text(
                              _ctr.list[index].shortName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontFamily: ZEN_DOTS,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
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
