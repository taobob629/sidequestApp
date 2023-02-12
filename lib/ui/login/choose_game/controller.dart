import 'dart:math';

import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/model/game_model.dart';

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
    pageState=PageState.loaded;
  }

  updateSelectedGames(SimpleGameModel item) {
    if( this.selected_games.contains(item)){
      selected_games.remove(item);
    }else{
      selected_games.add(item);
    }

  }
}
