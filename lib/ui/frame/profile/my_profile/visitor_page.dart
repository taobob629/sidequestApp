import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/ui/common/base_scaffold.dart';

import '../../../../api/user_api.dart';
import '../../../../common/getx_refresh_controller.dart';
import '../../../../config/app_color.dart';
import '../../../../model/vistor_model.dart';
import '../../../../utils/image_util.dart';

class VisitorPage extends StatelessWidget {

  final t = Get.put(VisitorListController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: 'Visitor'.tr,
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                      child: Row(
                        children: [
                          ImageUtil.networkImage(
                              url: model.avatar,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                          // if (model.isFans)
                          GestureDetector(
                            onTap: () {
                              t.unFollow(model.id);
                            },
                            child: Container(
                              height: 28,
                              width: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColor.itemBg,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Text("Unfollow",
                                  style: TextStyle(
                                      color: AppColor.whiteGray, fontSize: 13)),
                            ),
                          )
                          // else
                          // Container(
                          //   height: 28,
                          //   width: 76,
                          //   alignment: Alignment.center,
                          //   decoration: BoxDecoration(border: Border.all(color: AppColor.yellow), borderRadius: BorderRadius.circular(14)),
                          //   child: Text("+ Follow", style: TextStyle(color: AppColor.yellow, fontSize: 13)),
                          // )
                        ],
                      ),
                    );
                  })),
        ));
  }
}

class VisitorListController extends GetxRefreshController<VisitorModel> {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  unFollow(touid) {
    UserApi.attention(touid).then((value) {
      onRefresh();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<List<VisitorModel>> loadData({int pageNum = 1}) async {
    return await UserApi.visitorList(pageNum, 20);
  }
}
