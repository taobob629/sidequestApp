import 'package:wy/ui/frame/profile/model/album_item_model.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'package:wy/ui/frame/profile/model/rating_comment_model.dart';
import 'package:wy/ui/frame/profile/model/vip_info_model.dart';

import '../api/wy_http.dart';
import '../ui/frame/profile/model/game_detail_model.dart';
import '../ui/frame/profile/model/post_item_model.dart';
import '../ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';

abstract class ProfileApi {
  ProfileApi._();

  /// profile 用户信息
  static Future getProfileInfo() async {
    var response = await http.get('/peiwan/app/profile/info');
    return ProfileModel.fromJson(response.data);
  }

  /// profile-post  帖子列表
  static Future<List<PostItemModel>> getPostList({int page = 0, uid}) async {
    var response = await http.post('/peiwan/app/profile/listPost', data: {"pageNum": page, "pageSize": 20, "uid": uid});
    return response.data.map<PostItemModel>((e) => PostItemModel.fromJson(e)).toList();
  }

  /// profile-post  帖子列表
  static Future<List<PostItemModel>> getMyRepliedPostList({int page = 0, uid}) async {
    var response = await http.get('/peiwan/app/posts/myreply', queryParameters: {"pageNum": page, "pageSize": 20, "uid": uid});
    return response.data.map<PostItemModel>((e) => PostItemModel.fromJson(e)).toList();
  }

  /// profile-post  帖子列表
  static Future<List<PostItemModel>> getMyPraisedPostList({int page = 0, uid}) async {
    var response = await http.get('/peiwan/app/posts/mypraise', queryParameters: {"pageNum": page, "pageSize": 20, "uid": uid});
    return response.data.map<PostItemModel>((e) => PostItemModel.fromJson(e)).toList();
  }

  /// profile-post  点赞/取消点赞
  static Future praisePost({int postId = 0}) async {
    var response = await http.get('/peiwan/app/posts/praise', queryParameters: {
      "postsId": postId,
    });
    return response.data;
  }

  /// profile-post  点赞/取消点赞
  static Future deletePost({int postId = 0}) async {
    var response = await http.get('/peiwan/app/posts/delete_posts', queryParameters: {
      "postsId": postId,
    });
    return response.data;
  }

  /// profile-album  相册列表
  static Future<List<AlbumItemModel>> getPhotoList({int page = 0}) async {
    var response = await http.get('/peiwan/app/profile/getPhotos', queryParameters: {"pageNum": page, "pageSize": 20});
    return response.data["rows"].map<AlbumItemModel>((e) => AlbumItemModel.fromJson(e)).toList();
  }

  /// profile-album  添加图片到相册
  static Future addPhoto(String thumb) async {
    var response = await http.post('/peiwan/app/profile/addPhoto', data: {"thumb": thumb});
    return response.data;
  }

  /// profile-album  设置背景图
  static Future setBackground(String photoId) async {
    var response = await http.get('/peiwan/app/profile/setBackground', queryParameters: {"photoId": photoId});
    return response.data;
  }

  /// profile-album  删除图片
  static Future delPhoto(String photoId) async {
    var response = await http.post('/peiwan/app/profile/delPhoto/$photoId');
    return response.data;
  }

  /// vip详情
  static Future getVipDetail() async {
    var response = await http.get('/peiwan/app/profile/vipDetail');
    return response.data.map<VipInfoModel>((e) => VipInfoModel.fromJson(e)).toList();
  }

  /// player profile player用户信息
  static Future<PlayerInfoModel> getPlayerInfo({required playerId, gid}) async {
    var response = await http.get('/peiwan/app/profile/player', queryParameters: {"id": playerId, "gid": gid});
    return PlayerInfoModel.fromJson(response.data);
  }

  /// others-album  相册列表
  static Future<List<AlbumItemModel>> getOtherPhotos({int page = 0, required uid}) async {
    var response = await http.get('/peiwan/app/profile/getOtherPhotos', queryParameters: {"pageNum": page, "pageSize": 20, "uid": uid});
    return response.data["rows"].map<AlbumItemModel>((e) => AlbumItemModel.fromJson(e)).toList();
  }

  /// player profile player用户信息
  static Future profileInit() async {
    var response = await http.get('/peiwan/app/profile/profileInit');
    return response.data;
  }

  /// profile-album  添加图片到相册
  static Future updateProfile(String nick, String signature, String phone, String language, String country, String gender) async {
    var response = await http.post('/peiwan/app/profile/updateProfile', data: {"nick": nick, "signature": signature, "phone": phone, "language": language, "country": country, "gender": gender});
    return response.data;
  }

  /// player profile player用户信息
  static Future uk2id(uk) async {
    var response = await http.get('/peiwan/app/profile/uk2id', queryParameters: {"uk": uk});
    return response.data;
  }

  static Future<GameDetailModel> serviceDetailById(String id) async {
    var response = await http.get('/peiwan/app/users/serviceDetail?id=$id');
    return GameDetailModel.fromJson(response.data);
  }

  /// 查看自己的评价
  static Future<List<RatingCommentModel>> myCommentsList({int page = 1}) async {
    var response = await http.get('/peiwan/app/users/myComments', queryParameters: {
      "pageNum": page,
      "pageSize": 20,
    });
    return response.data["rows"].map<RatingCommentModel>((e) => RatingCommentModel.fromJson(e)).toList();
  }

  /// 查看别人的游戏评价
  static Future<List<RatingCommentModel>> othersCommentsList({int page = 1, required String liveid, required String skillId}) async {
    var response = await http.get('/peiwan/app/users/listComments', queryParameters: {
      "pageNum": page,
      "pageSize": 20,
      "liveid": liveid,
      "skillId": skillId,
    });
    return response.data["rows"].map<RatingCommentModel>((e) => RatingCommentModel.fromJson(e)).toList();
  }
}
