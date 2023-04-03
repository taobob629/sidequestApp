import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/widget/home/index.dart';

import '../../../image_utils.dart';
import '../../controller/user_controller.dart';
import '../view/tag/simple_tags.dart';
import 'controller.dart';

class SideKickMatchSucPage extends StatelessWidget {
  final _ctr = Get.put(SideKickMatchSucController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Sidekick Match',
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _matchingRequirementsWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.h,
                      childAspectRatio: 0.7 / 1.0),
                  itemBuilder: (c, i) {
                    if (i != _ctr.playerList.length) {
                      return _itemWidget(i);
                    } else {
                      return _blankWidget();
                    }
                  },
                  itemCount: _ctr.playerList.length + 1,
                ),
              ),
            ),
            Container(
              color: Color(0xff1b1a1e),
              height: 96.h,
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _ctr.cancelOrder(),
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          color: Colors.grey,
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_ctr.bean.uid ==
                      UserController.find.userProfile.value.pwId)
                    15.horizontalSpace,
                  if (_ctr.bean.uid ==
                      UserController.find.userProfile.value.pwId)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _ctr.selectItemList.isNotEmpty
                            ? () => _ctr.playGame()
                            : null,
                        child: Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: _ctr.selectItemList.isNotEmpty
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFD49C21),
                                      Color(0xFFE96524)
                                    ],
                                  ),
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  border: Border.all(
                                    color: Color(0xffF4C708),
                                    width: 1.w,
                                  ),
                                ),
                          child: Text(
                            'Play'.tr,
                            style: TextStyle(
                              color: Color(0xffF4C708),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
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
  }

  Widget _blankWidget() => Container(
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Color(0xffFFCB0E),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
              ),
              decoration: BoxDecoration(
                color: Color(0x99FFCB0E),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Color(0x33FFCB0E),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ],
        ),
      );

  Widget _itemWidget(int i) => Obx(
        () => GestureDetector(
          onTap: () => _ctr.selectItem(i),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff262731),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: _ctr.selectItemList.contains(_ctr.playerList[i])
                        ? Border.all(color: Color(0xffF4C708), width: 1.w)
                        : Border.all(color: Colors.transparent, width: 1.w),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.r),
                            topLeft: Radius.circular(15.r),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(_ctr.playerList[i].avatar),
                            fit: BoxFit.fill,
                          ),
                        ),
                        padding: EdgeInsets.only(right: 5.w, bottom: 8.h),
                        alignment: Alignment.bottomRight,
                        child: LocationWidget(_ctr.playerList[i].distance),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, top: 7.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                _ctr.playerList[i].nickname,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: FONT_MEDIUM),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            5.horizontalSpace,
                            SexAndAgeWidget(
                              age: _ctr.playerList[i].age,
                              sex: _ctr.playerList[i].sex,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 10.w,
                          top: 7.h,
                          bottom: 7.h,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageUtils.score1,
                              width: 13.w,
                              height: 13.w,
                            ),
                            5.horizontalSpace,
                            Text(
                              '${_ctr.playerList[i].stars}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          bottom: 7.h,
                        ),
                        child: Text(
                          '${_ctr.playerList[i].levelNameEn}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          bottom: 7.h,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageUtils.coinRed,
                              width: 15.w,
                              height: 15.w,
                            ),
                            4.horizontalSpace,
                            Text(
                              '${_ctr.playerList[i].price.toString()}/${_ctr.playerList[i].unit}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     margin: EdgeInsets.only(
                      //       left: 10.w,
                      //       top: 7.h,
                      //       bottom: 7.h,
                      //     ),
                      //     child: SimpleTags(
                      //       content: _ctr.bean.sendMatchModel.tags,
                      //       wrapSpacing: 4.w,
                      //       wrapRunSpacing: 4.w,
                      //       onTagPress: null,
                      //       tagContainerPadding: EdgeInsets.symmetric(
                      //           vertical: 6.h, horizontal: 10.w),
                      //       tagTextStyle: TextStyle(
                      //           color: Color(0xffc3c3c3), fontSize: 11.sp),
                      //       tagSelectTextStyle: TextStyle(
                      //           color: Color(0xffc3c3c3), fontSize: 11.sp),
                      //       tagContainerDecoration: BoxDecoration(
                      //         color: Color(0xff313033),
                      //         borderRadius: BorderRadius.circular(20.r),
                      //       ),
                      //       tagContainerSelectDecoration: BoxDecoration(
                      //         color: Color(0xff313033),
                      //         borderRadius: BorderRadius.circular(20.r),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    margin: EdgeInsets.only(top: 10.w, right: 10.w),
                    decoration: _ctr.selectItemList.contains(_ctr.playerList[i])
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageUtils.iconYixuanzhe),
                            ),
                          )
                        : BoxDecoration(
                            border: Border.all(
                                color: Color(0xffc3c3c3), width: 1.w),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _matchingRequirementsWidget() => Container(
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _ctr.showOrHideWidget,
              behavior: HitTestBehavior.translucent,
              child: Row(
                children: [
                  Image.asset(
                    ImageUtils.iconZhuansghi,
                    width: 17.w,
                    height: 17.w,
                  ),
                  10.horizontalSpace,
                  Text(
                    'Matching Requirements'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    _ctr.showOrHide.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _ctr.showOrHide.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1.h,
                    color: Color(0xff2D2E3A),
                    margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
                  ),
                  _commonWidget('Category'.tr, _ctr.bean.category),
                  20.verticalSpace,
                  _commonWidget('Game'.tr, _ctr.bean.game),
                  20.verticalSpace,
                  _commonWidget('Price Range'.tr, _ctr.bean.priceRange,
                      showIcon: true),
                  20.verticalSpace,
                  _commonWidget(
                    'Unit'.tr,
                    _ctr.bean.unit,
                  ),
                  20.verticalSpace,
                  _commonWidget(
                    'Language'.tr,
                    _ctr.bean.launguage,
                  ),
                  20.verticalSpace,
                  if (_ctr.bean.tags.isNotEmpty)
                    SimpleTags(
                      content: _ctr.bean.tags,
                      wrapSpacing: 10.w,
                      wrapRunSpacing: 10.h,
                      onTagPress: null,
                      tagContainerPadding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 15.w,
                      ),
                      tagTextStyle: TextStyle(
                        color: Color(0xffFFCB0E),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      tagSelectTextStyle: TextStyle(
                        color: Color(0xffFFCB0E),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      tagContainerDecoration: BoxDecoration(
                        color: Color(0xff3a3627),
                        border: Border.all(
                          color: Color(0xffFFCB0E),
                          width: 0.5.w,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      tagContainerSelectDecoration: BoxDecoration(
                        color: Color(0xff3a3627),
                        border: Border.all(
                          color: Color(0xffFFCB0E),
                          width: 0.5.w,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _commonWidget(String leftStr, String rightStr,
          {bool showIcon = false}) =>
      Row(
        children: [
          Text(
            leftStr,
            style: TextStyle(
                color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
          ),
          Expanded(child: SizedBox()),
          if (showIcon)
            Image.asset(
              "assets/images/coin_red.webp",
              width: 15.w,
              height: 15.w,
            ),
          5.horizontalSpace,
          Text(
            rightStr,
            style: TextStyle(
                color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
          ),
        ],
      );
}
