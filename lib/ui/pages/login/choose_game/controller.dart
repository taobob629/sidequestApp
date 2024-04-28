import 'package:get/get.dart';

import '../../../../api/game_api.dart';
import '../../../../common/base_controller.dart';
import '../../../../model/game_model.dart';
import '../../../../utils/toast_utils.dart';
import '../../main_page.dart';

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
      Get.offAll(() => MainPage());
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
