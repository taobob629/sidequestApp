import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/attention_model.dart';

class FollowListPage extends StatelessWidget {
  FollowListPage({Key? key}) : super(key: key);

  final t = Get.put(FollowListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                        ExtendedImage.network(
                          model.avatar,
                          width: 48,
                          height: 48,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.name,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                model.signature,
                                style: TextStyle(fontSize: 12, color: AppColor.whiteGray),
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
                            decoration: BoxDecoration(color: AppColor.itemBg, borderRadius: BorderRadius.circular(14)),
                            child: Text("Unfollow", style: TextStyle(color: AppColor.whiteGray, fontSize: 13)),
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
      ),
    );
  }
}

class FollowListController extends GetxRefreshController<AttentionModel> {
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

  unFollow(touid) {
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
    return await UserApi.followList(pageNum, 20);
    throw UnimplementedError();
  }
}
