/**
    author:mac
    创建日期:2023/3/21
    描述:
 */
import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/service_list_model.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

import 'controller.dart';

class OrderDetailPage extends GetView<OrderDetailPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                pinned: true,
                title: Text('Order details'.tr),
              )
            ];
          },
          body: Obx(() => controller.pageState == PageState.initialing
              ? buildLoad()
              : contentPadding(
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return orderDetailWidget(context);
                              case 1:
                                return evaluateWidget();
                              default:
                                return Container();
                            }
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.transparent,
                                height: 13.h,
                              ),
                          itemCount: 2))))),
    );
  }

  var textStyle2 = TextStyle(fontFamily: FONT_MEDIUM, fontSize: 13.sp);

  orderDetailWidget(BuildContext context) {
    var item = controller.model;
    return innnerBg(Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ImageUtil.networkImage(
                url: '${item?.userAvatar}', width: 32.w, height: 32.w, border: 16.w),
            InkWell(
              child: ImageUtil.assetImage('ic_message_yellow', width: 36.w, height: 36.w),
              onTap: () => controller.toChat(context),
            )
          ],
        ),
        divider(),
        Row(
          children: [
            ImageUtil.networkImage(
                url: '${item?.skillThumb}',
                width: 68.w,
                height: 68.w,
                border: 15.r,
                fit: BoxFit.cover),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item?.skillName}',
                  style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 14.sp),
                ),
                10.verticalSpace,
                Text(
                  '${item?.serviceItemName}  /${item?.unit}/ X${item?.amount}',
                  style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 12.sp),
                )
              ],
            )
          ],
        ),
        10.verticalSpace,
        rowLine('Status'.tr, orderStatusMap[item?.status]),
        rowLine('Order ID'.tr, item?.orderSn),
        rowLine('Order Time'.tr, item?.time),
        10.verticalSpace,
        listDivider,
        10.verticalSpace,
        rowLine2(
          'Subtotal'.tr,
          Row(
            children: [
              Image(
                image: AssetImage('assets/images/ic_balance_money.webp'),
                width: 15,
                height: 15,
              ),
              3.horizontalSpace,
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: '${item?.price}',
                    style:
                        TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
                TextSpan(
                    text: '/${item?.unit}',
                    style:
                        TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
              ])),
              //  Spacer(),
            ],
          ),
        ),
        rowLine2(
          'Discount'.tr,
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '${item?.discount}',
                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
          ])),
        ),
        5.verticalSpace,
        listDivider,
        5.verticalSpace,
        rowLine2(
          'Total'.tr,
          Row(
            children: [
              Image(
                image: AssetImage('assets/images/ic_balance_money.webp'),
                width: 15,
                height: 15,
              ),
              3.horizontalSpace,
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: '${item?.total}',
                    style:
                        TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
              ])),
              //  Spacer(),
            ],
          ),
        ),
      ],
    ));
  }

  rowLine(var leftText, var rightText) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8).h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$leftText',
            style: TextStyle(color: Color(0xFFB2B9C9), fontSize: 12.sp, fontFamily: FONT_LIGHT),
          ),
          Text('$rightText', style: TextStyle(fontSize: 12.sp, fontFamily: FONT_LIGHT)),
        ],
      ),
    );
  }

  rowLine2(var leftText, Widget rightWidget) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8).h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$leftText',
            style: textStyle2,
          ),
          rightWidget
        ],
      ),
    );
  }

  evaluateWidget() {
    return innnerBg(Column(
      children: [
        rowLine2(
            'User Rating'.tr,
            InkWell(
                onTap: () {},
                child: Text(
                  'Submit'.tr,
                  style: TextStyle(
                      color: AppColor.textYellow, fontFamily: FONT_MEDIUM, fontSize: 13.sp),
                ))),
        listDivider,
        10.verticalSpace,
        ...starLine(),
        10.verticalSpace,
        listDivider,
        comments()
      ],
    ));
  }

  double starSteps = 1;
  double starHeight = 20;
  double starWidth = 20;
  double starMargin = 16;

  starLine() {
    return [
      rowLine2('Performance'.tr, startItem(controller.starPer, type: 'Performance')),
      rowLine2('Responsive'.tr, startItem(controller.starRes, type: 'Responsive')),
      rowLine2('Enjoyment'.tr, startItem(controller.starEnj, type: 'Enjoyment')),
      rowLine2('Friendless'.tr, startItem(controller.starFri, type: 'Friendless')),
    ];
  }

  Obx startItem(RxDouble defaultStar, {var type}) {
    return Obx(() => FFStars(
          normalStar: Image.asset("assets/images/play/score0.png"),
          selectedStar: Image.asset("assets/images/play/score1.png"),
          step: starSteps,
          defaultStars: defaultStar.value,
          starHeight: 20,
          starWidth: 20,
          starMargin: 16,
          followChange: true,
          starsChanged: (double realStars, double selectedStars) {
            flog('$realStars $selectedStars');
            switch (type) {
              case 'Performance':
                controller.starPer.value = realStars;
                break;
              case 'Responsive':
                controller.starRes.value = realStars;
                break;
              case 'Enjoyment':
                controller.starEnj.value = realStars;
                break;
              case 'Friendless':
                controller.starFri.value = realStars;
                break;
            }
          },
        ));
  }

  comments() {
    return contentPadding(
        child: Container(
      constraints: BoxConstraints(minHeight: 100.h),
      child: TextField(
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        maxLength: 150,
        decoration: InputDecoration(
            border: InputBorder.none,
            label: ImageUtil.assetImage('ic_edit_yellow', width: 17.w),
            counterStyle: TextStyle(color: Colors.white60),
            // labelText: 'Please write down your comments'.tr,
            hintStyle: TextStyle(color: Color(0xFFB2B9C9), fontSize: 13.sp)),
      ),
    ));
  }
}

divider() {
  return Container(
    child: listDivider,
    padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
  );
}

Widget innnerBg(Widget view) {
  return Container(
    padding: itemPaddingNormal,
    decoration: itemDecoration(color: Color(0xFF262731), radius: 17.r),
    child: view,
  );
}
