import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/frame/game/game_home_ctr.dart';
import 'package:wy/widget/home/index.dart';

import '../../../config/app_color.dart';
import '../../../image_utils.dart';
import '../../../utils/image_util.dart';
import '../../controller/user_controller.dart';

class GameHomePage extends StatelessWidget {
  final _ctr = Get.put(GameHomeCtr());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'League of Legends'.tr,
      body: Column(
        children: [
          30.verticalSpace,
          _userInfoWidget(),
          15.verticalSpace,
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (c, i) => [
                SliverToBoxAdapter(
                  child: _gameInfoWidget(),
                ),
              ],
              body: _commentWidget(),
            ),
          ),
          if (!_ctr.isSelf)
            Container(
              height: 42.h + Get.mediaQuery.padding.bottom + 20,
              decoration: BoxDecoration(color: Color(0xff262731), boxShadow: [
                BoxShadow(
                    offset: Offset(0, -2.h),
                    color: Color(0xff1B1B21),
                    blurRadius: 5.h)
              ]),
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => UserController.find.jumpChat(_ctr.uk),
                  child: Container(
                    height: 42.h,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColor.yellowGradient),
                      borderRadius: BorderRadius.circular(21.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            "assets/images/profile/icon_pinlun.webp",
                            width: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Messages".tr,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration getBoxDecoration(int index) {
    if (index == 0) {
      return BoxDecoration(
        color: AppColor.itemBg,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.r),
          topLeft: Radius.circular(15.r),
        ),
      );
    } else if (index == _ctr.list.length - 1) {
      return BoxDecoration(
        color: AppColor.itemBg,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.r),
          bottomLeft: Radius.circular(15.r),
        ),
      );
    }

    return BoxDecoration(
      color: AppColor.itemBg,
    );
  }

  Widget _commentWidget() => Obx(
        () => SmartRefresher(
          controller: _ctr.refreshController,
          onRefresh: () => _ctr.onRefresh(),
          onLoading: () => _ctr.loadMore(),
          enablePullUp: true,
          child: ListView.builder(
            itemCount: _ctr.list.length,
            itemBuilder: (context, index) {
              final model = _ctr.list[index];
              return Container(
                margin: EdgeInsets.only(left: 15.w, right: 15.w),
                padding: EdgeInsets.all(15),
                decoration: getBoxDecoration(index),
                child: Column(children: [
                  if (index == 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColor.yellow,
                            ),
                            5.horizontalSpace,
                            Text(
                              '${_ctr.model?.stars}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            Container(
                              width: 4.w,
                              height: 4.w,
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            Text(
                              '${_ctr.total}Reviews',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  SizedBox(
                    height: 44.h,
                    child: Row(
                      children: [
                        ExtendedImage.network(
                          model.userAvatar,
                          width: 44.w,
                          height: 44.h,
                          fit: BoxFit.cover,
                          shape: BoxShape.circle,
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.nickName,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.sp)),
                              Text(model.fmtTime,
                                  style: TextStyle(
                                      color: Color(0XFF808388),
                                      fontSize: 12.sp)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                    child: Row(
                      children: [
                        Text("Performance".tr,
                            style: TextStyle(
                                color: Colors.white, fontSize: 13.sp)),
                        Spacer(),
                        RatingBar(
                          itemSize: 18.w,
                          unratedColor: Color(0xFF707070),
                          initialRating: model.performance.toDouble(),
                          ignoreGestures: true,
                          ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: AppColor.yellow,
                              ),
                              half: Icon(Icons.star),
                              empty: Icon(
                                Icons.star_border_rounded,
                                color: Color(0xFF707070),
                              )),
                          onRatingUpdate: (value) {},
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                    child: Row(
                      children: [
                        Text("Responsive".tr,
                            style: TextStyle(
                                color: Colors.white, fontSize: 13.sp)),
                        Spacer(),
                        RatingBar(
                          itemSize: 18.w,
                          unratedColor: Color(0xFF707070),
                          initialRating: model.responsive.toDouble(),
                          ignoreGestures: true,
                          ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: AppColor.yellow,
                              ),
                              half: Icon(Icons.star),
                              empty: Icon(
                                Icons.star_border_rounded,
                                color: Color(0xFF707070),
                              )),
                          onRatingUpdate: (value) {},
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                    child: Row(
                      children: [
                        Text("Enjoyment".tr,
                            style: TextStyle(
                                color: Colors.white, fontSize: 13.sp)),
                        Spacer(),
                        RatingBar(
                          itemSize: 18.w,
                          unratedColor: Color(0xFF707070),
                          initialRating: model.enjoyment.toDouble(),
                          ignoreGestures: true,
                          ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: AppColor.yellow,
                              ),
                              half: Icon(Icons.star),
                              empty: Icon(
                                Icons.star_border_rounded,
                                color: Color(0xFF707070),
                              )),
                          onRatingUpdate: (value) {},
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                    child: Row(
                      children: [
                        Text("Friendless".tr,
                            style: TextStyle(
                                color: Colors.white, fontSize: 13.sp)),
                        Spacer(),
                        RatingBar(
                          itemSize: 18.w,
                          unratedColor: Color(0xFF707070),
                          initialRating: model.friendless.toDouble(),
                          ignoreGestures: true,
                          ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: AppColor.yellow,
                              ),
                              half: Icon(Icons.star),
                              empty: Icon(
                                Icons.star_border_rounded,
                                color: Color(0xFF707070),
                              )),
                          onRatingUpdate: (value) {},
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.topLeft,
                    child: Text(model.content,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20.h,
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.h),
                            color: Color(0xFF3D3E48)),
                        child: Row(
                          children: [
                            ExtendedImage.network(
                              model.gameAvatar,
                              width: 13.w,
                              height: 13.h,
                              fit: BoxFit.fitWidth,
                            ),
                            4.horizontalSpace,
                            Text(model.gameName,
                                style: TextStyle(
                                    color: Color(0xFFC3C3C3), fontSize: 10.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Color(0xff2d2e3a),
                    height: 1.h,
                    margin: EdgeInsets.only(top: 30.h),
                  ),
                ]),
              );
            },
          ),
        ),
      );

  Widget _gameInfoWidget() => GetBuilder<GameHomeCtr>(
        builder: (builder) => Container(
          margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h),
          decoration: BoxDecoration(
            color: Color(0xff262731),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: [
              6.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: ImageUtil.networkImage(
                  url: _ctr.model?.backGround ?? '',
                  fit: BoxFit.cover,
                  height: 188.w,
                ),
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  _ctr.model?.intro ?? '',
                  style: TextStyle(
                    color: Color(0xff808388),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: FONT_MEDIUM,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Server'.tr,
                        style: TextStyle(
                            color: Color(0xff808388),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _ctr.model?.server ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Position'.tr,
                        style: TextStyle(
                            color: Color(0xff808388),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _ctr.model?.position ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Styles'.tr,
                        style: TextStyle(
                            color: Color(0xff808388),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _ctr.model?.style ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Platforms'.tr,
                        style: TextStyle(
                            color: Color(0xff808388),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _ctr.model?.platform ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM),
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
        id: _ctr.gameInfoId,
      );

  Widget _userInfoWidget() => Container(
        height: 110.h,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90.h,
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Color(0xff262731),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: ImageUtil.networkImage(
                        url: _ctr.avatar,
                        fit: BoxFit.cover,
                        width: 50.w,
                        height: 50.w,
                      ),
                    ),
                    12.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _ctr.nickName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        10.verticalSpace,
                        SexAndAgeWidget(
                          age: _ctr.age,
                          sex: _ctr.sex,
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              ImageUtils.coinRed,
                              width: 19.w,
                              height: 19.w,
                            ),
                            3.horizontalSpace,
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: '${double.parse(_ctr.price).floor()}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontFamily: FONT_MEDIUM)),
                              TextSpan(
                                  text: '/${_ctr.unit}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontFamily: FONT_MEDIUM)),
                            ]))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_ctr.model?.voice.isNotEmpty == true)
              Positioned(
                top: 0,
                right: 15.w,
                child: Container(
                  width: 98.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x29632BDA),
                          offset: Offset(0, 3.5),
                          blurRadius: 8,
                          spreadRadius: 0.5),
                      BoxShadow(
                          color: Color(0x29FFFFFF),
                          offset: Offset(0, -1.5),
                          blurRadius: 10,
                          spreadRadius: 0.5),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //播放
                          _ctr.audioManager.play(_ctr.model?.voice);
                        },
                        child: Row(
                          children: [
                            10.horizontalSpace,
                            Image.asset(
                                "assets/images/profile/icon_voice_play.webp",
                                width: 20,
                                height: 20),
                            8.horizontalSpace,
                            Image.asset(
                                "assets/images/profile/icon_voice_progress.webp",
                                height: 13.h,
                                fit: BoxFit.cover),
                            4.horizontalSpace,
                            Image.asset(
                                "assets/images/profile/icon_voice_progress.webp",
                                height: 13.h,
                                fit: BoxFit.cover),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      );
}
