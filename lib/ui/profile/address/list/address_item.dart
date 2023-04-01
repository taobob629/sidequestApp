import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/icon_text.dart';

class AddressItem extends StatelessWidget {
  final AddressModel address;
  final Function? onTap;
  final Function onEdit;

  AddressItem({
    required this.address,
    required this.onEdit,
    this.onTap,
  });

  var divider = 8.verticalSpace;
  var textColor = Color(0xffB2B9C9);
  var iconColor = Color(0xffB2B9C9);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap?.call(),
        child: address.useDefault
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.h),
                    height: 5.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3).h),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFE68887), Color(0xFFBE39CC), Color(0xff612AD7)],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.h),
                    padding: itemPaddingNormal,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/address_item_bg.webp'))),
                    child: list_item(address.useDefault),
                  ),
                ],
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: itemPaddingNormal,
                clipBehavior: Clip.antiAlias,
                decoration: itemDecoration(),
                child: list_item(address.useDefault),
              ));
  }

  Widget list_item(var isDefault) {
    if (isDefault) {
      textColor = Colors.white;
      iconColor = AppColor.yellow;
    }
    return Column(
      children: [
        5.verticalSpace,
        Row(
          children: [
            Text(
              "${address.firstName} ${address.lastName}",
              style: TextStyle(
                  color: address.useDefault ? AppColor.textYellow : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM),
            ),
            isDefault ? Spacer() : 25.horizontalSpace,
            Text(
              "${address.phone}",
              style: TextStyle(
                color: address.useDefault ? AppColor.textYellow : Colors.white,
                fontFamily: FONT_LIGHT,
                fontSize: 16.sp,
              ),
            ),
            Offstage(
              offstage: !address.useDefault,
              child: Container(
                decoration:
                    BoxDecoration(color: AppColor.accent, borderRadius: BorderRadius.circular(4)),
                margin: EdgeInsets.only(left: 5).w,
                padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 2.h, bottom: 2.h),
                child: Text(
                  "Default".tr,
                  style: TextStyle(color: Colors.white, fontSize: 11.sp),
                ),
              ),
            ),
            // Spacer(),
            if (isDefault == false) Spacer(),
            if (isDefault == false)
              GestureDetector(
                  onTap: () => onEdit.call(),
                  child: ImageUtil.assetImage('ic_edit_circle', width: 29.w, height: 29.h)),
          ],
        ),
        10.verticalSpace,
        listDivider,
        10.verticalSpace,
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTextWidget(
              textColor: textColor,
              iconColor: iconColor,
              icon: 'ic_email',
              text: address.email,
              size: 13.w,
            ),
            divider,
            IconTextWidget(
              textColor: textColor,
              iconColor: iconColor,
              icon: 'ic_location',
              text: "${address.line1} | ${address.line2} | ${address.city} | ${address.postCode}",
              size: 13.w,
            ),
            divider,
            IconTextWidget(
              icon: 'ic_nav',
              iconColor: iconColor,
              textColor: textColor,
              text: address.postCode,
              size: 13.w,
            ),
          ],
        ))
      ],
    );
  }
}
