import 'package:get/get.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';

import '../../../profile/model/post_item_model.dart';

class PostListController extends GetxRefreshController<PostItemModel> {
  static PostListController get find => Get.find();

  final list = <PostItemModel>[].obs;

  @override
  void onInit() {
    // getPostList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // getPostList() {
  //   PostApi.getPostList().then((value) {
  //     list.value = value;
  //     list.refresh();
  //   });
  // }

  Future<bool> praisePost(PostItemModel post) async {
    try {
      var resp = await PostApi.praisePost(postsId: post.uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<PostItemModel>> loadData({int pageNum = 1}) async {
    return await PostApi.getPostList(page: pageNum);
    // TODO: implement loadData
    throw UnimplementedError();
  }
}
