/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/network_method.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/model/game_section.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:wy/utils/utils.dart';
import 'package:dio/src/response.dart' as dio;

List<KeyMap> gameInitFilter = [
  KeyMap('语言'.tr, null),
  KeyMap('性别'.tr, null),
  KeyMap('等级'.tr, null),
  KeyMap('段位'.tr, null)
];

class SideKickController extends RefreshListController<GameUserModel> {
  RxList<KeyMap?> filters = RxList(gameInitFilter);

  RxInt _currentSelectIndex = RxInt(0);

  int get currentSelectIndex => _currentSelectIndex.value;

  set currentSelectIndex(int value) {
    _currentSelectIndex.value = value;
  }

  RxList<SimpleGameModel> gameList = RxList();

  Rxn<GameSectionModel?> _gameSections = Rxn();

  GameSectionModel? get gameSections => _gameSections.value;

  set gameSections(GameSectionModel? value) {
    _gameSections.value = value;
  }

  getGameSection() async {
    try {
      gameSections = await GamesApi.getGamesSection(gameList[currentSelectIndex].id);
    } catch (e) {
      flog('gameSection catchErr e $e');
    }
  }

  getGamePlayers() {
    initData();
  }

  void choseSelect(index) {
    currentSelectIndex = index;
    onRefresh();
  }

  @override
  void onInit() {
    super.onInit();
    init();
    _currentSelectIndex.listen((value) {});
  }

  init() async {
    await initMyGames();
    await getGameSection();
    await getGamePlayers();
  }

  Future<void> initMyGames() async {
    var result = await GamesApi.getMyGamesList();
    gameList.clear();
    gameList.addAll(result);
  }

  @override
  buildMethodType() {
    return NWMethod.GET;
  }

  @override
  Map<String, dynamic> buildParams() => {};

  @override
  String buildUrl() {
    var filterParams = {
      "language": "${filters[0]?.value}",
      "gender": "${filters[1]?.value}",
      "level": "${filters[2]?.value}",
      "gamelevel": "${filters[3]?.value}",
    };
    var gid = gameList[currentSelectIndex].id;
    var searchParams = jsonEncode(filterParams);
    return '/peiwan/app/new/superlist?pageNum=$page&pageSize=$pageSize&gid=$gid&searchParams=$searchParams';
  }

  @override
  bool paged() => true;

  @override
  List<GameUserModel> dealData(dio.Response<dynamic> response) {
    return response.data.map<GameUserModel>((item) => GameUserModel.fromJson(item)).toList();
  }

  @override
  needAutoLoadData() => false;

  onSectionChange(int section, int index) {
    switch (section) {
      case 0:
        filters[section] = gameSections?.language[index];
        break;
      case 1:
        filters[section] = gameSections?.genders[index];
        break;
      case 2:
        filters[section] = gameSections?.levels[index];
        break;
      case 3:
        filters[section] = gameSections?.gameLevel[index];
        break;
    }
    onRefresh();
  }

  toGameListPage() {
    Get.toNamed(AppPages.MoreGames);
  }
}
