/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';

const int TYPE_FOLLOW = 0;
const int TYPE_FANS = 1;

class AttentionUserListPage extends GetView<AttentionListPageController> {
  final type;

  AttentionUserListPage(this.type) {
    Get.put(AttentionListPageController(this.type), tag: 'attention_${type}');
  }

  @override
  AttentionListPageController get controller => GetInstance().find<AttentionListPageController>(tag: 'attention_${type}');

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Obx(() => SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refresh,
          onLoading: controller.loadMore,
          enablePullUp: true,
          child: controller.initializing.value
              ? Container()
              : controller.list.length == 0
                  ? Stack(
                      children: [
                        Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: EmptyView())
                      ],
                    )
                  : CustomScrollView(
                      slivers: [
                        Obx(() {
                          return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                            return item(index, controller.list[index]);
                          }, childCount: controller.list.length));
                        })
                      ],
                    ))),
    );
  }

  item(int index, AttentionModel user) {
    return ListTile(
      leading: GestureDetector(
        onTap: (){
          flog('user.id ${user.id}');
          Get.to(() => PlayDetail(userId:'${user.id}'));
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CachedNetworkImage(
                imageUrl: user.avatar ?? '',
                fit: BoxFit.cover,
                imageBuilder: (context, provider) {
                  return Container(
                    width: 48,
                    height: 48,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.cover,
                        )),
                  );
                },
              ))),),
      title: Row(
        children: [
          Text(user.name ?? 'Unkown',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          PWidget.boxw(5),
          user.sex==0?Icon(Icons.male,color: Colors.white,size: 16,):   CircleAvatar(
              radius: 8,
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage(
                    'assets/images/${user.sex == 0 ? 'ic_male' : 'ic_female'}.webp'),
                height: 16,
              ))
        ],
      ),
      subtitle: Text(
        '${user.signature ?? ''}',
        style: TextStyle(color: Color.fromRGBO(88, 99, 126, 1), fontSize: 12),
        maxLines: 1,
      ),
      trailing: button(index, user),
    );
  }

  button(int index, AttentionModel user) {
    //   int type = user.status ?? 0;
    if (type == TYPE_FOLLOW) {
      return MaterialButton(
        minWidth: 60,
        color: Color.fromRGBO(40, 62, 90, 1),
        textColor: Color.fromRGBO(130, 145, 180, 1),
        child: Text(
          'Unfollow',
        ),
        onPressed: () {
          controller.unfollow(index, user.id);
        },
        shape: StadiumBorder(),
        height: 28,
      );
    }
    return Obx(() => Container(
          height: 28,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: user.status.value == BOTH_FOCUS
                      ? [
                          Color.fromRGBO(40, 62, 90, 1),
                          Color.fromRGBO(40, 62, 90, 1),
                        ]
                      : [Color(0xFFFC3C02), Color(0xFF841FC3)])),
          child: MaterialButton(
            elevation: 0,
            minWidth: 60,
            color: Colors.transparent,
            textColor: user.status.value == BOTH_FOCUS
                ? Color.fromRGBO(130, 145, 180, 1)
                : Colors.white,
            child: user.status.value == BOTH_FOCUS
                ? Container(
                    width: 30,
                    child: Image(
                      image: AssetImage('assets/images/ic_exchange.webp'),
                      height: 16,
                      width: 24,
                    ),
                  )
                : Text(
                    'Follow',
                  ),
            onPressed: () {
              controller.fanceFollow(index, user);
            },
            height: 28,
          ),
        ));
  }
}
