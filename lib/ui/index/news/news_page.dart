import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/news_detail_model.dart';
import 'package:wy/model/news_item_model.dart';
import 'package:wy/ui/common/flexible_header.dart';
import 'package:wy/ui/common/page_title.dart';

import '../../../utils/toast_utils.dart';
import 'news_info.dart';
import 'news_text.dart';
import 'news_title.dart';

class NewsPage extends StatelessWidget {

  final int id;
  late final NewsPageController controller;

  NewsPage({required this.id}){
    controller = Get.put(NewsPageController(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          Obx(() {
            return SliverAppBar(
              elevation: 0,
              pinned: true,
              backgroundColor: AppColor.background,
              expandedHeight: controller.headerHeight.value,
              title: PageTitle(
                title: controller.title.value,
                color: controller.titleColor.value,
              ),
              flexibleSpace: controller.headerImage.value.isEmpty ? null : FlexibleHeader(
                image: controller.headerImage.value,
              )
            );
          }),
          Obx(() {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                  NewsContent nc = controller.list[index];
                  switch (nc.type) {
                    case 1:
                      return NewsTitle(nc.content);
                    case 2:
                      return NewsInfo(nc.content);
                    case 3:
                      return NewsText(nc.content);
                    default:
                      return Container();
                  }
                },
                childCount: controller.list.length
              )
            );
          })
        ],
      )
    );
  }
}

class NewsPageController extends GetxListController<NewsContent> {

  int id;

  var title = "".obs;

  var headerImage = "".obs;

  var titleColor = Colors.transparent.obs;

  var headerHeight = 300.0.obs;

  late ScrollController scrollController;

  NewsPageController({required this.id});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >= headerHeight.value - kToolbarHeight) {
        if (titleColor.value == Colors.transparent) {
          changeTitleColor(Colors.white);
        }
      } else {
        if (titleColor.value == Colors.white) {
          changeTitleColor(Colors.transparent);
        }
      }
    });
  }

  @override
  void onClose() {
    dismissLoading();
    scrollController.dispose();
    super.onClose();
  }

  Future<List<NewsContent>> loadData() async {
    showLoading();
    NewsDetailModel detail = await IndexApi.getNewsDetail(id);
    dismissLoading();

    headerImage.value = detail.image;

    List<NewsContent> list = [];
    NewsContent nc = NewsContent();
    nc.type = 1;
    nc.content = detail.title;
    list.add(nc);
    this.title.value = nc.content;

    nc = NewsContent();
    nc.type = 2;
    nc.content = "${detail.time},${detail.author}";
    list.add(nc);

    nc = NewsContent();
    nc.type = 3;
    nc.content = detail.content;
    list.add(nc);

    return list;
  }

  void changeTitleColor(Color titleColor) {
    this.titleColor.value = titleColor;
  }
}