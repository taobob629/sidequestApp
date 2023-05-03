import 'dart:math';

import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/utils/toast_utils.dart';
import 'package:wy/utils/utils.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */

class ChooseGamePageController extends BasePageController {
  RxList<SimpleGameModel> games = RxList();
  RxList<SimpleGameModel> selected_games = RxList();

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
    pageState = PageState.loaded;
  }

  Future<void> followGames() async {
    var gameIds = selected_games.map((game) => game.id).toList();
    var result = await GamesApi.addRegisterFavorite(gameIds);

    if (result.statusCode == 200) {
      Get.offAllNamed(AppPages.Main);
    } else {
      showError(result.statusMessage);
    }
  }

  updateSelectedGames(SimpleGameModel item) {
    if (this.selected_games.contains(item)) {
      selected_games.remove(item);
    } else {
      int itemCount = selected_games.length;
      if (itemCount >= 4) {
        showToast('Up to Four'.tr);
        return;
      }
      selected_games.add(item);
    }
  }
}
