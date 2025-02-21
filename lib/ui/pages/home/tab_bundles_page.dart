import 'package:badges/badges.dart' as badges;
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';

import '../../../api/hubs_api.dart';
import '../../../api/index_api.dart';
import '../../../common/dialog_selector.dart';
import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../model/bubble_tea_store_model.dart';
import '../../../model/bundles_model.dart';
import '../../../service/location_service.dart';
import '../../../utils/toast_utils.dart';
import '../../../widget/image_util.dart';
import 'bundle_confirm_order_page.dart';
import 'bundles_detail_page.dart';

class TabBundlesPage extends StatelessWidget {
  final controller = TabBundlesPageController.find;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            10.verticalSpace,
            InkWell(
              onTap: () => controller.selectStore(),
              child: Container(
                padding: EdgeInsets.all(8.r),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColor.yellow.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => RichText(
                                text: TextSpan(
                                  text:
                                      '${controller.currentSelectStore.value.name}  ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.white,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          6.verticalSpace,
                          Obx(() => RichText(
                                text: TextSpan(
                                  text: controller.minDistances.value >= 1000
                                      ? "${(controller.minDistances.value / 1000).toStringAsFixed(2)}km"
                                      : "${controller.minDistances.value.toStringAsFixed(2)}m",
                                  style: TextStyle(
                                    color: const Color(0xFFFFB20E),
                                    fontSize: 12.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " away from you",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12.sp,
                                        fontFamily: 'DIN',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Image.asset(
                      ImageUtils.bubble_tea_store_icon,
                      width: 52.w,
                      height: 38.h,
                    ),
                    16.horizontalSpace,
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: Stack(
                children: [
                  Obx(() => ListView.separated(
                        itemBuilder: (c, i) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Get.to(() => BundlesDetailPage(),
                              arguments: {
                                "id": controller.list[i].id,
                                "index": i
                              }),
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
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (c, i) => 10.verticalSpace,
                        itemCount: controller.list.length,
                      )),
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
        ),
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

class TabBundlesPageController extends GetxController {
  static TabBundlesPageController get find => Get.find();

  var isShowDrinkNow = true.obs;
  late BuildContext cartContext;
  var selectList = <BundlesModel>[].obs;
  var totalPrice = "0".obs;
  var minDistances = 0.0.obs;

  // 优惠券前的总价
  String yhTotalPrice = "0";
  var storesList = <BubbleTeaStoreModel>[].obs;
  var currentSelectStore = BubbleTeaStoreModel().obs;
  var list = <BundlesModel>[].obs;

  @override
  void onReady() {
    super.onReady();

    requestStoreList();
  }

  void requestStoreList() async {
    showLoading();
    storesList.value = await HubsApi.getStores();
    if (storesList.isNotEmpty) {
      for (int i = 0; i < storesList.length; i++) {
        if (storesList[i].map != null) {
          List<String> latLog =
              storesList[i].map!.replaceAll(" ", "").split(",");
          double distances = Geolocator.distanceBetween(
            LocationService().position.value?.latitude ?? 51.51272691932477,
            LocationService().position.value?.longitude ?? -0.12896615379992515,
            double.parse(latLog[0]),
            double.parse(latLog[1]),
          );
          if (i == 0) {
            minDistances.value = distances;
          }

          print('distances = $distances, $i');
          // sb.value += "${storesList[i].name}和当前设备相距：$distances";

          if (distances < minDistances.value) {
            minDistances.value = distances;
            currentSelectStore.value = storesList[i];
          }
        }
      }
      if (currentSelectStore.value.id == null) {
        currentSelectStore.value = storesList.first;
      }
      requestData(currentSelectStore.value.id, false);
    } else {
      dismissLoading();
    }
  }

  void requestData(int? storeId, bool isShowLoading) async {
    if (isShowLoading) showLoading();
    list.value = await IndexApi.getBundles(storeId);
    dismissLoading(status: SmartStatus.loading);
  }

  void addTea(int i) {
    final result =
        selectList.firstWhereOrNull((element) => element.id == list[i].id);
    if (result == null) {
      selectList.add(list[i]);
    }

    totalPrice.value = selectList.fold<String>("0",
        (previousValue, element) => previousValue.add(element.price ?? "0"));
    yhTotalPrice = totalPrice.value;
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

  void selectStore() async {
    final value = await Get.dialog(SelectorDialog(
      items: storesList,
      title: "Select Store".tr,
      showInfo: true,
    ));
    if (value != null) {
      currentSelectStore.value = value as BubbleTeaStoreModel;
      requestData(currentSelectStore.value.id, true);

      if (currentSelectStore.value.map != null) {
        List<String> latLog =
            currentSelectStore.value.map!.replaceAll(" ", "").split(",");

        minDistances.value = Geolocator.distanceBetween(
          LocationService().position.value?.latitude ?? 51.51272691932477,
          LocationService().position.value?.longitude ?? -0.12896615379992515,
          double.parse(latLog[0]),
          double.parse(latLog[1]),
        );
      }

      clearTea();
      requestData(currentSelectStore.value.id, true);
    }
  }

  List<Map<String, dynamic>> getGoodsListMap() {
    List<Map<String, dynamic>> goodsList = [];
    selectList.forEach((element) {
      Map<String, dynamic> map = {
        "id": element.id,
        "num": element.count.value,
        "commodityId": element.commodityId,
      };
      goodsList.add(map);
    });
    return goodsList;
  }
}
