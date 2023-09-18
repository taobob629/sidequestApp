
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/banner_model.dart' as custom;
import 'package:wy/model/game_model.dart';
import 'package:wy/ui/common/banner_view.dart';
import 'package:wy/ui/index/popular_game_view.dart';
import 'package:wy/ui/index/support_game_view.dart';

class TabGamesPage extends StatelessWidget {

  final controller = Get.put(TabGamePageController());

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery
      .of(context)
      .size
      .width - 30) * 19 / 34;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          expandedHeight: height,
          flexibleSpace: FlexibleSpaceBar(
            background: Obx(()=>controller.banners.isEmpty ? Container():BannerView(banners: controller.banners,))
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
            child: Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Popular Games".tr,
                    style: TextStyle(fontSize: 18, fontFamily: "din", color: Colors.white),
                  ),
                ),
                  Image.asset("assets/images/ic_fire.webp", height: 20,)
                ],
              )
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return Row(
                    children: _buildPopularList(controller.popularList),
                  );
                }),
              )
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
            child: Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Supported Games".tr,
                    style: TextStyle(fontSize: 18, fontFamily: "din", color: Colors.white),
                  ),
                ),
                ],
              )
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: Obx(() {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                  GameModel game = controller.list[index];
                  return SupportGameView(game: game,);
                },
                childCount: controller.list.length
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 11 / 15
              )
            );
          }),
        )
      ],
    );
  }

  List<Widget> _buildPopularList(List<GameModel> popularList) {
    List<Widget> list = [];
    for (int i = 0; i < popularList.length; i++) {
      GameModel game = popularList[i];
      list.add(PopularGameView(game:game, index: i+1, last: i == popularList.length - 1,));
    }
    return list;
  }
}

class TabGamePageController extends GetxListController<GameModel> {
  static TabGamePageController get find => Get.find();

  RxList<GameModel> popularList = RxList();

  RxList<custom.BannerModel> banners = RxList();

  @override
  void onReady() async{
    super.onReady();
    banners.clear();
    banners.addAll(await IndexApi.getBanners(9));
  }

  Future<List<GameModel>> loadData() async {
    List<GameModel> list = await IndexApi.getGames();

    list.forEach((model) {
      if(model.popular){
        popularList.add(model);
      }
    });
    return list;
  }
}