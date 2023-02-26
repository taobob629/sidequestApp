import 'package:wy/api/wy_http.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';

class PostApi {
  PostApi._();
  //Social-发布post
  static Future releasePost({content = "", images = const []}) async {
    var response = await http.post('/peiwan/app/posts/posts', data: {
      "content": content,
      "images": images,
    });
    return response.data;
  }

  /// Social-Post  帖子列表
  static Future<List<PostItemModel>> getPostList({int page = 0}) async {
    var response = await http.post('/peiwan/app/posts/list', data: {
      "pageNum": page,
      "pageSize": 20,
    });
    return response.data.map<PostItemModel>((e) => PostItemModel.fromJson(e)).toList();
  }
}
