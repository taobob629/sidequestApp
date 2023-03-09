import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';

import '../contorller/post_detail_controller.dart';
import '../model/post_comment_model.dart';

class PostFavoratorsPage extends StatelessWidget {
  PostFavoratorsPage({Key? key}) : super(key: key);
  final t = Get.put(PostFavoratorsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SmartRefresher(
          controller: t.refreshController,
          onRefresh: () => t.onRefresh(),
          onLoading: () => t.loadData(),
          child: ListView.separated(
            itemCount: t.list.length,
            itemBuilder: (context, index) {
              final model = t.list[index];
              return GestureDetector(
                onTap: () {
                  t.replyModel.value = model;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: ExtendedImage.network(
                            model.isReply ? model.replyHead : model.head,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      model.isReply ? model.replyNickname : model.nickname,
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                model.createTime.toDateStr,
                                style: TextStyle(color: Color(0xff808388), fontSize: 13),
                              )
                            ],
                          ),
                        )),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/profile/icon_dianzan.webp",
                            width: 16,
                            color: Colors.pink,
                          ),
                        ),
                        SizedBox(width: 5)
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: AppColor.itemBg,
                height: 1,
              );
            },
          ),
        ),
      );
    });
  }
}

class PostFavoratorsController extends GetxRefreshController<PostCommentModel> {
  PostItemModel postItem = PostItemModel();
  TextEditingController commentController = TextEditingController();

  final replyModel = PostCommentModel().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    postItem = Get.arguments;
    super.onInit();
  }

  postComment() {
    PostApi.postComment(postsId: postItem.uid, content: commentController.text, replyId: replyModel.value.uid).whenComplete(() {
      onRefresh();
      replyModel.value = PostCommentModel();
      commentController.clear();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<PostCommentModel>> loadData({int pageNum = 0}) async {
    // TODO: implement loadData
    return await PostApi.getFavoratorsList(page: pageNum, postsId: postItem.id);
    throw UnimplementedError();
  }
}
