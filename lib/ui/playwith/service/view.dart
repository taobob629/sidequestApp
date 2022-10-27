/**
    author:mac
    创建日期:2022/9/22
    描述:
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/game_service_model.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/service/controller.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/views.dart';

class MoreGamesPage extends GetView<MoreGamesPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Services'),
          centerTitle: true,
          elevation: 0,
          bottom: _buildTabs(),
        ),
        body: Obx(() => controller.services.isEmpty
            ? buildLoad()
            : TabBarView(
                controller: controller.tabController,
                children: createPages())));
  }

  _buildTabs() {
    return PreferredSize(
        child: Obx(() => controller.services.isEmpty
            ? Container()
            : TabBar(
                controller: controller.tabController,
                isScrollable: false,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: Colors.white38,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                indicator: HomeIndicator(colors: [
                  Color.fromRGBO(252, 60, 2, 1),
                  Color.fromRGBO(132, 31, 195, 1)
                ]),
                indicatorPadding: EdgeInsets.only(bottom: 5),
                labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 20, fontFamily: "din"),
                tabs: controller.services
                    .map((tab) => Text(tab.category))
                    .toList(),
              )),
        preferredSize: Size(Get.width, 46));
  }

  List<Widget> createPages() {
    return controller.services
        .map((item) => buildGameList(item.games))
        .toList();
  }

  Widget buildGameList(List<GameInfo> items) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView.separated(
          itemBuilder: (context, index) => ListTile(
                isThreeLine: false,
                leading: PWidget.container(
                  CachedNetworkImage(
                    imageUrl: items[index].url,
                    fit: BoxFit.cover,
                  ),
                  [64, 56 + 24, Colors.white10],
                  {'crr': 12},
                ),
                trailing: Obx(() => IconButton(
                      icon: Icon(
                        Icons.star,
                        color: items[index].favorite == 0
                            ? Colors.white10
                            : Colors.orange,
                      ),
                      onPressed: () => Get.find<UserController>()
                          .checkLogin(() => controller.focus(items[index])),
                    )),
                /* subtitle: Text(
                items[index].desc,
                style: TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white60),
                maxLines: 2,
              ),*/
                title: PWidget.text(
                    items[index].gameName, [Colors.white, 18], {'ff': 'DIN'}),
              ),
          separatorBuilder: (context, index) => Divider(color: AppColor.itemBg,),
          itemCount: items.length),
    );
  }
}
