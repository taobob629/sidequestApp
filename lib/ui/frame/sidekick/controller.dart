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
import 'package:wy/utils/utils.dart';

class SideKickController extends GetxController {
  RxInt _currentSelectIndex = RxInt(0);

  int get currentSelectIndex => _currentSelectIndex.value;

  set currentSelectIndex(int value) {
    _currentSelectIndex.value = value;
  }

  RxList<SimpleGameModel> gameList = RxList();
  RefreshController refreshController=RefreshController();
  getGames() async {
    gameList.clear();
    var result = await GamesApi.getMyGamesList();
    gameList.addAll(result);
  }
 void choseSelect(index){

  }
  @override
  void onInit() {
    super.onInit();
    getGames();
  }
}
