import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';
import 'package:wy/ui/frame/social/post/view/give_gifts_dialog.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/index.dart';

import '../../../../../utils/toast_utils.dart';
import '../contorller/post_detail_controller.dart';
import '../model/post_comment_model.dart';
import '../view/gift_animation.dart';
import '../view/gift_suc_anim.dart';

class PostCommentsPage extends StatelessWidget {
  PostCommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Get.put(PostCommentController());

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
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 80),
                itemCount: t.list.length,
                itemBuilder: (context, index) {
                  final model = t.list[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (UserController.find.userProfile.pwId != model.uid) {
                        t.replyModel.value = model;
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                NavigatorHelper.toOtherProfile(model.uid);
                              },
                              child: ClipOval(
                                child: ImageUtil.networkImage(
                                  url: model.isReply ? model.replyHead : model.head,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
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
                                          model.addTime.toDateStr,
                                          style: TextStyle(color: Color(0xff808388), fontSize: 14, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  RichText(
                                      text: TextSpan(style: TextStyle(fontSize: 14, color: Colors.white), children: [
                                    if (model.isReply) ...[
                                      TextSpan(text: "reply ".tr),
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
            Obx(() => Positioned(
                height: 50,
                left: 0,
                right: 0,
                bottom: t.marginBottom.value,
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
                                    focusNode: t.commentNode,
                                    decoration: InputDecoration(
                                        hintText: t.replyModel.value.nickname.isNotEmpty ? "reply:".tr + t.replyModel.value.nickname : "Comment".tr,
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
                      Visibility(
                        visible: !t.isSelf && UserController.find.online.value,
                        child: GestureDetector(
                          onTapDown: (details) async {
                            var heartNum = await Get.bottomSheet(
                                GiveGiftsDialog(
                                  receiverId: t.postItem.uid.toString(),
                                  postId: t.postItem.id.toString(),
                                  avatar: t.postItem.head,
                                ),
                                ignoreSafeArea: true);
                            if (heartNum != null) {
                              Future.delayed(Duration(milliseconds: 300)).then(
                                (v) {
                                  SmartDialog.show(
                                    builder: (builder) => GiftSucAnim(heartNum),
                                    displayTime: Duration(seconds: 2),
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
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
                          ),
                        ),
                      )
                    ],
                  ),
                )))
          ],
        ),
      );
    });
  }
}

class PostCommentController extends GetxRefreshController<PostCommentModel> {
  PostItemModel postItem = PostItemModel();
  TextEditingController commentController = TextEditingController();
  FocusNode commentNode = FocusNode();

  final replyModel = PostCommentModel().obs;
  bool isSelf = false;

  final marginBottom = 30.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    postItem = Get.arguments;
    isSelf = UserController.find.userProfile.pwId == postItem.uid;
    commentNode.addListener(() {
      if (commentNode.hasFocus) {
        marginBottom.value = 0.0;
      } else {
        marginBottom.value = 30.0;
      }
    });
    super.onInit();
  }

  postComment() {
    if (commentController.text.trim().isEmpty) {
      showInfo("Please enter comment!".tr);
      return;
    }
    PostApi.postComment(postsId: postItem.id, content: commentController.text, replyId: replyModel.value.uid).whenComplete(() {
      showSuccess('${'Comments'.tr} ${'Success'.tr}!');
      onRefresh();
      replyModel.value = PostCommentModel();
      PostDetailController.find.postItem.value.commentNum += 1;
      PostDetailController.find.postItem.refresh();
      commentController.clear();
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
    return await PostApi.getPostCommentsList(page: pageNum, postsId: postItem.id);
    throw UnimplementedError();
  }
}
