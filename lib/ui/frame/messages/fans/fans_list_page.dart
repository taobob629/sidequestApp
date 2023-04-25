import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/navigator_helper.dart';

import '../../../../widget/home/sex_age_widget.dart';
import '../../../common/base_scaffold.dart';

class FansListPage extends StatelessWidget {
  FansListPage({Key? key}) : super(key: key);

  final t = Get.put(FansListController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'My Followers'.tr,
      body: Obx(
        () => SmartRefresher(
            controller: t.refreshController,
            onLoading: () => t.loadMore(),
            onRefresh: () => t.onRefresh(),
            enablePullUp: true,
            child: ListView.builder(
                itemCount: t.list.length,
                itemBuilder: (context, index) {
                  final model = t.list[index];
                  return Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () =>
                                NavigatorHelper.toOtherProfile(model.id),
                            child: ImageUtil.networkImage(
                                url: model.avatar,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover)),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    model.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  6.horizontalSpace,
                                  SexAndAgeWidget(
                                    age: model.age,
                                    sex: model.sex,
                                  ),
                                ],
                              ),
                              Text(
                                model.signature,
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.whiteGray),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )),
                        if (model.status.value == 1)
                          GestureDetector(
                            onTap: () {
                              t.followOrNot(model.id);
                            },
                            child: Container(
                              height: 28,
                              width: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColor.itemBg,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Image.asset(
                                  "assets/images/ic_exchange.webp",
                                  width: 16,
                                  height: 16),
                            ),
                          )
                        else
                          GestureDetector(
                              onTap: () {
                                t.followOrNot(model.id);
                              },
                              child: Container(
                                height: 28,
                                width: 76,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.yellow),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Text("+ Follow",
                                    style: TextStyle(
                                        color: AppColor.yellow, fontSize: 13)),
                              ))
                      ],
                    ),
                  );
                })),
      ),
    );
  }
}

class FansListController extends GetxRefreshController<AttentionModel> {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  followOrNot(touid) {
    UserApi.attention(touid).then((value) {
      onRefresh();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<AttentionModel>> loadData({int pageNum = 1}) async {
    // TODO: implement loadData
    return await UserApi.fansList(pageNum, 20);
  }
}
