import 'package:wy/ui/frame/profile/model/album_item_model.dart';
import 'package:wy/ui/frame/profile/model/vip_info_model.dart';

import '../api/wy_http.dart';
import '../ui/frame/profile/model/post_item_model.dart';

abstract class ProfileApi {
  ProfileApi._();

  /// profile 用户信息
  static Future getProfileInfo() async {
    var response = await http.get('/peiwan/app/profile/info');
    return response.data;
  }

  /// profile-post  帖子列表
  static Future<List<PostItemModel>> getPostList({int page = 1}) async {
    var response = await http.post('/peiwan/app/profile/listPost', data: {
      "pageNum": page,
      "pageSize": 20,
    });
    return response.data.map<PostItemModel>((e) => PostItemModel.fromJson(e)).toList();
  }

  /// profile-post  点赞/取消点赞
  static Future praisePost({int postId = 0}) async {
    var response = await http.get('/peiwan/app/posts/praise', queryParameters: {
      "postsId": postId,
    });
    return response.data;
  }

  /// profile-album  相册列表
  static Future<List<AlbumItemModel>> getPhotoList() async {
    var response = await http.get('/peiwan/app/profile/getPhotos');
    return response.data.map<AlbumItemModel>((e) => AlbumItemModel.fromJson(e)).toList();
  }

  /// profile-album  添加图片到相册
  static Future addPhoto(String thumb) async {
    var response = await http.post('/peiwan/app/profile/addPhoto', data: {"thumb": thumb});
    return response.data;
  }

  /// vip详情
  static Future getVipDetail() async {
    var response = await http.get('/peiwan/app/profile/vipDetail');
    return response.data.map<VipInfoModel>((e) => VipInfoModel.fromJson(e)).toList();
  }
}
