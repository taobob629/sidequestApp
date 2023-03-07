import 'package:wy/api/wy_http.dart';
import 'package:wy/ui/frame/profile/model/post_item_model.dart';
import 'package:wy/ui/frame/social/post/model/post_comment_model.dart';

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

  /// Social-Post  帖子列表
  static Future praisePost({required int postsId}) async {
    var response = await http.get('/peiwan/app/posts/praise', queryParameters: {"postsId": postsId});
    return response.data;
  }

  /// Social-Post  帖子列表
  static Future<List<PostCommentModel>> getPostCommentsList({int postsId = 0, int page = 0}) async {
    var response = await http.get('/peiwan/app/posts/comment/list', queryParameters: {
      "postsId": postsId,
      "pageNum": page,
      "pageSize": 20,
    });
    return response.data.map<PostCommentModel>((e) => PostCommentModel.fromJson(e)).toList();
  }

  /// Social-Post  帖子列表
  static Future postComment({required int postsId, required String content, int? replyId, images}) async {
    var response = await http.post('/peiwan/app/posts/comment', data: {
      "postsId": postsId,
      "replyId": replyId,
      "content": content,
      "images": images,
    });
    return response.data;
  }

  /// Social-Post  帖子列表
  static Future<List<PostCommentModel>> getFavoratorsList({int postsId = 0, int page = 0}) async {
    var response = await http.get('/peiwan/app/posts/praise/list', queryParameters: {
      "postsId": postsId,
      "pageNum": page,
      "pageSize": 20,
    });
    return response.data.map<PostCommentModel>((e) => PostCommentModel.fromJson(e)).toList();
  }
}
