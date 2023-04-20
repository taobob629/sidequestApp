import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../api_service/profile_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../service/voice_player.dart';
import '../../controller/user_controller.dart';
import '../profile/model/game_detail_model.dart';
import '../profile/model/rating_comment_model.dart';

class GameHomeCtr extends GetxRefreshController<RatingCommentModel> {
  String liveid = "";
  int gameId = 0;
  String skillId = "";
  String avatar = "";
  String nickName = "";
  String uk = "";
  String price = "0.0";
  String unit = "";
  int age = 0;
  int sex = 0;
  int total = 0;
  bool isSelf = false;

  String gameInfoId = "gameInfoId";
  GameDetailModel? model;

  AudioManager audioManager = AudioManager.instance;

  @override
  void onInit() {
    if (Get.arguments is Map) {
      liveid = Get.arguments["liveid"].toString();
      skillId = Get.arguments["skillId"].toString();
      avatar = Get.arguments["avatar"].toString();
      nickName = Get.arguments["nickName"].toString();
      price = Get.arguments["price"].toString();
      unit = Get.arguments["unit"].toString();
      uk = Get.arguments["uk"].toString();
      age = Get.arguments["age"] ?? 0;
      sex = Get.arguments["sex"] ?? 0;
      gameId = Get.arguments["gameId"] ?? 0;
    }
    isSelf = UserController.find.userProfile.pwId.toString() == liveid;
    super.onInit();

    _requestData();
  }

  @override
  void onClose() {
    super.onClose();
    AudioManager.instance.stop();
  }

  void _requestData() async {
    model = await ProfileApi.serviceDetailById(gameId);
    update([gameInfoId]);
  }

  @override
  Future<List<RatingCommentModel>> loadData({int pageNum = 1}) async {
    var response = await ProfileApi.othersCommentsList(liveid: liveid, skillId: skillId);
    total = response["total"];
    return response["rows"].map<RatingCommentModel>((e) => RatingCommentModel.fromJson(e)).toList();
  }
}
