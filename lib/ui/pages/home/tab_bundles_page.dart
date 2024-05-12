import 'package:badges/badges.dart' as badges;
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';

import '../../../api/index_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../model/bundles_model.dart';
import '../../../utils/toast_utils.dart';
import '../../../widget/image_util.dart';
import 'bundle_confirm_order_page.dart';
import 'bundles_detail_page.dart';

class TabBundlesPage extends StatelessWidget {
  final controller = TabBundlesPageController.find;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SmartRefresher(
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.loadMore,
                  enablePullUp: true,
                  enablePullDown: true,
                  child: Obx(() => ListView.separated(
                    itemBuilder: (c, i) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.to(() => BundlesDetailPage(),
                          arguments: controller.list[i].id),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                            InkWell(
                              onTap: () => controller.addTea(i),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 10.w,
                                  top: 40.h,
                                ),
                                child: Image.asset(
                                  ImageUtils.bundles_cart_icon,
                                  scale: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (c, i) => 10.verticalSpace,
                    itemCount: controller.list.length,
                  )),
                ),
                Obx(() => Visibility(
                  visible: controller.selectList.isNotEmpty &&
                      controller.isShowDrinkNow.value,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: drinkNowWidget(16.w),
                  ),
                )),
              ],
            ),
          ),
          Builder(builder: (context) {
            controller.cartContext = context;
            return 0.verticalSpace;
          }),
        ],
      );

  Widget cartWidget() => Container(
        constraints: BoxConstraints(
          maxHeight: 300.h,
          minHeight: 100.h,
          minWidth: 1.sw,
        ),
        decoration: ShapeDecoration(
          color: hexColor('141517'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "${controller.selectList.length}  ",
                      style: TextStyle(
                        color: hexColor('FFB20E'),
                        fontSize: 14.sp,
                        fontFamily: 'DIN',
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'item in total',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14.sp,
                            fontFamily: 'DIN',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ).paddingOnly(left: 16.w),
                ),
                InkWell(
                  onTap: () => controller.clearTea(),
                  child: Image.asset(ImageUtils.delete_icon),
                ),
                16.horizontalSpace,
              ],
            ),
            controller.selectList.length <= 3
                ? commonWidget(true)
                : Expanded(child: commonWidget(false)),
            drinkNowWidget(16.w),
          ],
        ),
      );

  Widget commonWidget(bool shrinkWrap) => Obx(() => ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: shrinkWrap,
        itemBuilder: (c, i) => Container(
          height: 70.h,
          child: Row(
            children: [
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${controller.selectList[i].name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Visibility(
                      visible: controller.selectList[i].brief != null,
                      child: Text(
                        '${controller.selectList[i].brief}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10.sp,
                          fontFamily: FONT_LIGHT,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '£ ${controller.selectList[i].price}',
                style: TextStyle(
                  color: Color(0xFFFFB20E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ).paddingSymmetric(horizontal: 10.w),
              Obx(() => InkWell(
                    onTap: () => controller.minusMoney(i),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: controller.selectList[i].count.value == 1
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white,
                    ),
                  )),
              Obx(() => Text(
                    '${controller.selectList[i].count.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_LIGHT,
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingSymmetric(horizontal: 15.w)),
              InkWell(
                onTap: () => controller.addMoney(i),
                child: Icon(
                  Icons.add_circle_outline,
                  color: hexColor('#FFB20E'),
                ),
              ),
              16.horizontalSpace,
            ],
          ),
        ),
        separatorBuilder: (c, i) => Container(
          height: 1.h,
          decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
        ),
        itemCount: controller.selectList.length,
      ));

  Widget drinkNowWidget(double horizontal) => Container(
        height: 44.w,
        decoration: ShapeDecoration(
          color: hexColor('4C3608'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.r),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: horizontal),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.isShowDrinkNow.value = false;
                SmartDialog.showAttach(
                    targetContext: controller.cartContext,
                    usePenetrate: false,
                    alignment: Alignment.topCenter,
                    builder: (_) => cartWidget(),
                    onDismiss: () => controller.isShowDrinkNow.value = true);
              },
              child: badges.Badge(
                showBadge: controller.selectList.isNotEmpty,
                badgeContent: Text(
                  '${controller.selectList.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                badgeColor: hexColor('FF4848'),
                position: badges.BadgePosition(top: -8.h),
                alignment: Alignment.topRight,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: ShapeDecoration(
                    color: hexColor('141517'),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.w, color: hexColor('FFB20E')),
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                  ),
                  child: Image.asset(
                    ImageUtils.drink_now_icon,
                    scale: 2,
                  ),
                ),
              ),
            ),
            14.horizontalSpace,
            Obx(() => Text(
              '£${controller.totalPrice.value}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.w600,
              ),
            )),
            Expanded(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Discount：-0.0 ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.6),
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.to(() => BundleConfirmOrderPage()),
              child: Container(
                width: 100.w,
                height: 44.w,
                decoration: ShapeDecoration(
                  color: hexColor('FFB20E'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Buy Now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class TabBundlesPageController extends GetxRefreshController<BundlesModel> {
  static TabBundlesPageController get find => Get.find();

  var isShowDrinkNow = true.obs;
  late BuildContext cartContext;
  var selectList = <BundlesModel>[].obs;
  var totalPrice = "0".obs;

  @override
  Future<List<BundlesModel>> loadData(
      {int pageNum = GetxRefreshController.pageNumFirst}) async {
    List<BundlesModel> list = await IndexApi.getBundles();
    return list;
  }

  void addTea(int i) {
    final result =
        selectList.firstWhereOrNull((element) => element.id == list[i].id);
    if (result == null) {
      selectList.add(list[i]);
      showSuccess("Successful.".tr);
    } else {
      showError("You've already added it.".tr);
    }

    totalPrice.value = selectList.fold<String>("0",
        (previousValue, element) => previousValue.add(element.price ?? "0"));
  }

  void clearTea() {
    selectList.clear();
    dismissLoading();
  }

  void addMoney(int i) {
    selectList[i].count.value += 1;
    calculateTotal();
  }

  void minusMoney(int i) {
    if (selectList[i].count.value > 1) {
      selectList[i].count.value -= 1;
      calculateTotal();
    }
  }

  void calculateTotal() {
    Decimal total = Decimal.parse("0");
    for (BundlesModel item in selectList) {
      total += Decimal.parse(item.getTotalPrice());
    }
    totalPrice.value = total.toString();
  }
}
