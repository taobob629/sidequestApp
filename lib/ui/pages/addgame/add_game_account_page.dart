import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../config/icon_font.dart';
import '../../../image_utils.dart';
import 'add_game_account_ctr.dart';

class AddGameAccountPage extends StatelessWidget {
  final ctr = Get.put(AddGameAccountCtr());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20.h,
          ),
          child: Text(
            'Link your game account to the SideQuest account'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: FONT_LIGHT,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        30.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            20.horizontalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(25.w),
              child: SvgPicture.asset(
                ImageUtils.add_game_account_content,
                width: 50.w,
              ),
            ),
            20.horizontalSpace,
            Text(
              'Link Riot account'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: FONT_LIGHT,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            IconButton(
              onPressed: ctr.jumpWeb,
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
            20.horizontalSpace,
          ],
        ),
        Expanded(
          child: Obx(() => ListView.separated(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.fromLTRB(
                    26.w,
                    14.h,
                    18.w,
                    14.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${ctr.list[i].lolName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: FONT_LIGHT,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => ctr.deleteAccount(ctr.list[i].id),
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (c, i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  color: Colors.white10,
                  height: 1.h,
                ),
                itemCount: ctr.list.length,
              )),
        ),
      ],
    );
  }
}
