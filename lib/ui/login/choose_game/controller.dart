import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/model/game_model.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */

class ChooseGamePageController extends GetxController {
  RxList<SimpleGameModel> games = RxList();

  RxInt _count = RxInt(0);

  RxInt get count => _count;

  set count(RxInt value) {
    _count = value;
  }

  @override
  void onInit() {
    super.onInit();
    initGameList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initGameList() async {
    var result = await GamesApi.getRecommendGames();
    games?.addAll(result);
  }
}
