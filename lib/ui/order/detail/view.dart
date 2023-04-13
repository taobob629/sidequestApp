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
import 'package:timelines/timelines.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/order_detail.dart';
import 'package:wy/model/service_list_model.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/im/dialog_comment.dart';
import 'package:wy/ui/order/controller.dart';
import 'package:wy/ui/order/detail/widgets/widgets.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/stadium_button.dart';
import 'package:wy/widget/views.dart';

import 'controller.dart';
import 'widgets/acticon_widget.dart';

class OrderDetailPage extends GetView<OrderDetailPageController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        appBar: AppBar(
          title: Text('Order details'.tr),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Obx(() => controller.pageState == PageState.initialing
                ? buildLoad()
                : contentPadding(
                    child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return orderDetailWidget(context);
                                case 1:
                                  return evaluateWidget();
                                case 2:
                                  return commentsWidget();
                                default:
                                  return Container();
                              }
                            },
                            separatorBuilder: (context, index) => Divider(
                                  color: Colors.transparent,
                                  height: 13.h,
                                ),
                            itemCount: controller.model?.history?.isNotEmpty == true ? 3 : 2))))),
        btnBar: bottom_bar());
  }

  Widget bottom_bar() {
    return Obx(() => controller.model == null ? buildLoad() : ActionWidget());
  }

  orderDetailWidget(BuildContext context) {
    var item = controller.model;
    return innnerBg(Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: ImageUtil.networkImage(url: '${item?.userAvatar}', fit: BoxFit.cover, width: 32.w, height: 32.w, border: 16.w),
                  onTap: () {
                    // NavigatorHelper.toOtherProfile(item?.pwuserId);
                  },
                ),
                4.horizontalSpace,
                Text(
                  '${item?.nickName}',
                  style: TextStyle(fontSize: 14.sp, fontFamily: FONT_LIGHT),
                )
              ],
            ),
            // InkWell(
            //   child: ImageUtil.assetImage('ic_message_yellow', width: 36.w, height: 36.w),
            //   // onTap: () => controller.toChat(context),
            // )
          ],
        ),
        divider(),
        Row(
          children: [
            ImageUtil.networkImage(url: '${item?.skillThumb}', width: 68.w, height: 68.w, border: 15.r, fit: BoxFit.cover),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${item?.skillName}',
                  style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 14.sp),
                ),
                5.verticalSpace,
                Text(
                  '${item?.serviceItemName}',
                  style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 12.sp),
                ),
                5.verticalSpace,
                SizedBox(
                  height: 20,
                  width: Get.width - 70.w - 78.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/images/ic_balance_money.webp'),
                            width: 15,
                            height: 15,
                          ),
                          3.horizontalSpace,
                          Text.rich(TextSpan(children: [
                            TextSpan(text: '${item?.price}', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: FONT_MEDIUM)),
                            TextSpan(text: '/${item?.unit}', style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: FONT_MEDIUM)),
                          ])),
                        ],
                      ),
                      Text(
                        'X${item?.amount}',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 12.sp),
                      ),
                    ],
                  ),
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
                TextSpan(text: '${item?.subtotal}', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
                // TextSpan(
                //     text: '/${item?.unit}',
                //     style:
                //         TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
              ])),
              //  Spacer(),
            ],
          ),
        ),
        rowLine2(
          'Discount'.tr,
          Text.rich(TextSpan(children: [
            TextSpan(text: '${item?.discount}', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
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
                TextSpan(text: '${item?.total}', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
              ])),
              //  Spacer(),
            ],
          ),
        ),
      ],
    ));
  }

  evaluateWidget() {
    if (controller.model?.status == -2 || (controller.model?.status == 2 && controller.type == TYPE_ORDER_PROVIDED)) {
      return innnerBg(Column(
        children: [
          rowLine2(
              'User Rating'.tr,
              Visibility(
                  //  visible: !readOnly(),
                  visible: false,
                  child: InkWell(
                      onTap: () {
                        controller.finishOrder();
                      },
                      child: Text(
                        'Submit'.tr,
                        style: TextStyle(color: AppColor.textYellow, fontFamily: FONT_MEDIUM, fontSize: 13.sp),
                      )))),
          listDivider,
          10.verticalSpace,
          ...starLine(),
          10.verticalSpace,
          listDivider,
          comments()
        ],
      ));
    }
    return Container();
  }

  commentsWidget() {
    List<CommentsModel> history = controller.model?.history ?? [];
    if (history.isEmpty == true) return Container();
    return innnerBg(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      rowLine2('Order Timeline'.tr, Container()),
      10.verticalSpace,
      FixedTimeline.tileBuilder(
          //  contentsAlign: ContentsAlign.basic,
          mainAxisSize: MainAxisSize.min,
          theme: TimelineThemeData(color: AppColor.yellow),
          builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.basic,
              oppositeContentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${history[index].time}',
                      style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 10.sp, color: Colors.white60),
                    ),
                  ),
              connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${history[index].content}', style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 12.sp, color: Colors.white)),
                  ),
              itemCount: history.length))
    ]));
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
          justShow: readOnly(),
          normalStar: ImageUtil.assetImage('score0'),
          selectedStar: ImageUtil.assetImage('score1'),
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

  readOnly() {
    if (controller.type == TYPE_ORDER_RECEIVED) return true; //下单人都只是展示
    return controller.model?.status != 2;
  }

  comments() {
    return Container(
      constraints: BoxConstraints(minHeight: 100.h),
      child: TextField(
        readOnly: readOnly(),
        controller: controller.etCommnetController,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        maxLength: 150,
        decoration: InputDecoration(
            border: InputBorder.none,
            label: controller.model?.status == 2 ? ImageUtil.assetImage('ic_edit_yellow', width: 17.w) : null,
            counterStyle: TextStyle(color: Colors.white60),
            // labelText: 'Please write down your comments'.tr,
            hintStyle: TextStyle(color: Color(0xFFB2B9C9), fontSize: 13.sp)),
      ),
    );
  }
}
