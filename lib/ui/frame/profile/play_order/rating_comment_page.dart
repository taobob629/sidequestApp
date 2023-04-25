import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/profile/model/rating_comment_model.dart';
import 'package:wy/ui/order/detail/widgets/widgets.dart';

import '../../../controller/user_controller.dart';

class RatingCommentController extends GetxRefreshController<RatingCommentModel> {
  String liveid = "";
  String skillId = "";
  bool isSelf = true;
  @override
  void onInit() {
    // TODO: implement onInit
    if (Get.arguments is Map) {
      liveid = Get.arguments["liveid"].toString();
      skillId = Get.arguments["skillId"].toString();
      isSelf = UserController.find.userProfile.pwId.toString() == liveid;
    }
    super.onInit();
  }

  @override
  Future<List<RatingCommentModel>> loadData({int pageNum = 1}) async {
    // TODO: implement loadData
    if (isSelf) {
      return ProfileApi.myCommentsList();
    } else {
      var response = await ProfileApi.othersCommentsList(liveid: liveid, skillId: skillId);
      return response["rows"].map<RatingCommentModel>((e) => RatingCommentModel.fromJson(e)).toList();
    }
  }
}

class RatingCommentPage extends StatelessWidget {
  const RatingCommentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Get.put(RatingCommentController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments".tr),
      ),
      body: Obx(() => SmartRefresher(
            controller: t.refreshController,
            onRefresh: () => t.onRefresh(),
            onLoading: () => t.loadMore(),
            enablePullUp: true,
            child: ListView.builder(
              itemCount: t.list.length,
              itemBuilder: (context, index) {
                final model = t.list[index];
                return Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: AppColor.itemBg, borderRadius: BorderRadius.circular(15)),
                  child: Column(children: [
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
                                Text(model.nickName, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                Text(model.fmtTime, style: TextStyle(color: Color(0XFF808388), fontSize: 12.sp)),
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
                          Text("Performance".tr, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
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
                          Text("Responsive".tr, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
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
                          Text("Enjoyment".tr, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
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
                          Text("Friendless".tr, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
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
                    Divider(
                      color: Color(0xFF2D2E3A),
                      height: 1,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.topLeft,
                      child: Text(model.content, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20.h,
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.h), color: Color(0xFF3D3E48)),
                          child: Row(
                            children: [
                              ExtendedImage.network(
                                model.gameAvatar,
                                width: 13.w,
                                height: 13.h,
                                fit: BoxFit.fitWidth,
                              ),
                              4.horizontalSpace,
                              Text(model.gameName, style: TextStyle(color: Color(0xFFC3C3C3), fontSize: 10.sp)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                );
              },
            ),
          )),
    );
  }
}
