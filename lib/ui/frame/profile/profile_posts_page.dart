import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api_service/profile_api.dart';

import 'model/post_item_model.dart';

class ProfilePostsPage extends StatelessWidget {
  ProfilePostsPage({Key? key}) : super(key: key);

  final t = Get.put(ProfilePostsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
          padding: EdgeInsets.only(top: 15),
          itemCount: t.list.length,
          separatorBuilder: (context, index) {
            return Divider(
              color: Color(0XFF262731),
              height: 1.5,
            );
          },
          itemBuilder: (context, index) {
            return _postItemView(t.list[index]);
          }),
    );
  }

  Widget _postItemView(PostItemModel model) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: ExtendedImage.network(
                    model.head,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              model.nickname,
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "4h",
                              style: TextStyle(color: Color(0xff808388), fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Text(
                        model.content,
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Visibility(
            visible: model.images.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                model.images,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/images/profile/icon_pinlun.webp",
                          width: 16,
                        ),
                      ),
                      Text(
                        model.commentNum.toString(),
                        style: TextStyle(
                          color: Color(0xff808388),
                          fontSize: 11.sp,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  // onTap: () => t.praisePost(model),
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            "assets/images/profile/icon_dianzan.webp",
                            width: 16,
                            color: model.isPraise == 1 ? Colors.pink : null,
                          ),
                        ),
                        Text(
                          model.praiseNum.toString(),
                          style: TextStyle(
                            color: Color(0xff808388),
                            fontSize: 11.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/images/profile/icon_liwu.webp",
                          width: 16,
                        ),
                      ),
                      // Text(
                      //   model.commentNum.toString(),
                      //   style: TextStyle(
                      //     color: Color(0xff808388),
                      //     fontSize: 11.sp,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePostsController extends GetxController with GetSingleTickerProviderStateMixin {
  static ProfilePostsController get find => Get.find();

  final list = <PostItemModel>[].obs;

  @override
  void onInit() {
    getPostList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getPostList() {
    ProfileApi.getPostList().then((value) {
      list.value = value;
      list.refresh();
    });
  }

  praisePost(PostItemModel post) {
    ProfileApi.praisePost(postId: post.uid).then((value) {
      getPostList();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
