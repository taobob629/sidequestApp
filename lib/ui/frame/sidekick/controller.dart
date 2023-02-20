/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/model/game_section.dart';
import 'package:wy/ui/frame/sidekick/widget/section.dart';
import 'package:wy/utils/utils.dart';

class SideKickController extends GetxController {
  RxList filters = RxList(gameFilter);

  RxInt _currentSelectIndex = RxInt(0);

  int get currentSelectIndex => _currentSelectIndex.value;

  set currentSelectIndex(int value) {
    _currentSelectIndex.value = value;
  }

  RxList<SimpleGameModel> gameList = RxList();
  RefreshController refreshController = RefreshController();

  getGames() async {
    // gameList.clear();
    await GamesApi.getMyGamesList().then((value) {
      gameList.addAll(value);
      getGameSection();
    });
  }

  Rxn<GameSectionModel?> _gameSections = Rxn();

  GameSectionModel? get gameSections => _gameSections.value;

  set gameSections(GameSectionModel? value) {
    _gameSections.value = value;
  }

  getGameSection() async {
    try {
      gameSections =
          await GamesApi.getGamesSection(gameList[currentSelectIndex].id).whenComplete(() {
        getGameList();
      });
    } catch (e) {
      flog('gameSection catchErr e $e');
    }
  }

  getGameList() async {
    try {
      gameSections =
          await GamesApi.getGamesSection(gameList[currentSelectIndex].id).whenComplete(() {});
    } catch (e) {
      flog('gameSection e $e');
    }
    flog('gameSection $gameSections');
  }

  void choseSelect(index) {}

  void onRefresh() {
    if (gameList.isEmpty) getGames();
    //getGames();
  }

  @override
  void onInit() {
    super.onInit();
    getGames();
  }
}
