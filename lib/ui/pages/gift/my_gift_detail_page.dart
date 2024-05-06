import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/string_ext.dart';

import '../../../common/styles.dart';
import '../../../config/icon_font.dart';
import '../../../widget/scaffold_widget.dart';
import '../order/detail/widgets/widgets.dart';
import '../setting/about_page.dart';
import 'my_gift_detail_ctr.dart';

class MyGiftDetailPage extends StatelessWidget {
  final _ctr = Get.put(MyGiftDetailCtr());

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('My Gift details'.tr),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: contentPadding(
          child: GetBuilder<MyGiftDetailCtr>(
            builder: (builder) => MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: orderDetailWidget(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderDetailWidget(BuildContext context) {
    if (_ctr.model == null) {
      return Container();
    }

    var item = _ctr.model;
    return innnerBg(Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CachedNetworkImage(
                      imageUrl: '${item?.avatar}',
                      fit: BoxFit.cover,
                      width: 32.w,
                      height: 32.w,
                    ),
                  ),
                  onTap: () {
                    // NavigatorHelper.toOtherProfile(item?.pwuserId);
                  },
                ),
                4.horizontalSpace,
                Text(
                  '${item?.nickname}',
                  style: TextStyle(fontSize: 14.sp, fontFamily: FONT_LIGHT),
                )
              ],
            ),
          ],
        ),
        divider(),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: CachedNetworkImage(
                imageUrl: '${item?.giftImage}',
                width: 68.w,
                height: 68.w,
                fit: BoxFit.cover,
              ),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${item?.giftName}',
                  style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 14.sp),
                ),
                15.verticalSpace,
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: FONT_MEDIUM)),
                    ])),
                  ],
                ),
              ],
            )
          ],
        ),
        10.verticalSpace,
        rowLine('Order ID'.tr, item?.orderId),
        rowLine('Order Time'.tr, item?.addtime.toDateStr),
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
                    text: '${item?.subtotal}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM)),
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
            TextSpan(
                text: '${item?.discount}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM)),
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM)),
              ])),
            ],
          ),
        ),
      ],
    ));
  }
}
