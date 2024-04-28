import '../api/wy_http.dart';
import '../model/profile_detail.dart';
import '../model/profile_model.dart';

abstract class ProfileApi {
  ProfileApi._();

  /// profile 用户信息
  static Future getProfileInfo() async {
    var response = await http.get('/peiwan/app/profile/memberInfo');
    return ProfileModel.fromJson(response.data);
  }

  /// 查看别人的游戏评价
  static Future<Map> othersCommentsList({int page = 1, required String liveid, required String skillId}) async {
    var response = await http.get('/peiwan/app/users/listComments', queryParameters: {
      "pageNum": page,
      "pageSize": 20,
      "liveid": liveid,
      "skillId": skillId,
    });
    return response.data;
  }

  /// player profile player用户信息
  static Future<ProfileDetailBean> profileInit() async {
    var response = await http.get('/peiwan/app/profile/profileInit');
    return  ProfileDetailBean.fromJson(response.data);
  }

  /// profile-album  添加图片到相册
  static Future updateProfile(String nick, String phone, String country, String gender) async {
    var response = await http.post('/peiwan/app/profile/updateProfile', data: {"nick": nick, "phone": phone, "country": country, "gender": gender});
    return response.data;
  }
}
