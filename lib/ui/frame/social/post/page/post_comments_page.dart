import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';

import '../contorller/post_detail_controller.dart';
import '../model/post_comment_model.dart';

class PostCommentsPage extends StatelessWidget {
  PostCommentsPage({Key? key}) : super(key: key);
  final t = Get.put(PostCommentController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SmartRefresher(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text(
                                          model.createTime.toDateStr,
                                          style: TextStyle(color: Color(0xff808388), fontSize: 14, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  RichText(
                                      text: TextSpan(style: TextStyle(fontSize: 14, color: Colors.white), children: [
                                    if (model.isReply) ...[
                                      TextSpan(text: "reply "),
                                      TextSpan(text: model.nickname + " : ", style: TextStyle(color: AppColor.yellow, fontWeight: FontWeight.bold)),
                                    ],
                                    TextSpan(text: model.content),
                                  ])),
                                ],
                              ),
                            ))
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

            ///评论输入框
            Positioned(
                height: 50,
                left: 0,
                right: 0,
                bottom: 30,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: AppColor.color3033, borderRadius: BorderRadius.circular(25)),
                            padding: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Obx(() => Expanded(
                                        child: TextFormField(
                                      controller: t.commentController,
                                      decoration: InputDecoration(
                                          hintText: t.replyModel.value.nickname.isNotEmpty ? "reply:" + t.replyModel.value.nickname : "Comment",
                                          hintStyle: TextStyle(color: AppColor.textSubtitle, fontSize: 14)),
                                    ))),
                                GestureDetector(
                                  onTap: () => t.postComment(),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset("assets/images/post/icon_send.png", width: 20, height: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(color: AppColor.color3033, borderRadius: BorderRadius.circular(25)),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/post/icon_gift.png",
                            width: 24,
                            height: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }
}

class PostCommentController extends GetxRefreshController<PostCommentModel> {
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
  Future<List<PostCommentModel>> onRefresh({bool init = false}) {
    // TODO: implement onRefresh
    return super.onRefresh().whenComplete(() {
      PostDetailController.find.postItem.value.commentNum = list.length;
      PostDetailController.find.postItem.refresh();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<PostCommentModel>> loadData({int pageNum = 1}) async {
    // TODO: implement loadData
    return await PostApi.getPostCommentsList(page: pageNum, postsId: postItem.uid);
    throw UnimplementedError();
  }
}
