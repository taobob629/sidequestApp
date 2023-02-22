import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/simple_user_info_model.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/ui/playwith/play_profile_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/paixs_widget.dart';

import 'controller.dart';

class SearchUserPage extends GetView<SearchUserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white10), borderRadius: BorderRadius.circular(8)),
          child: TextField(
            maxLines: 1,
            focusNode: controller.focusNode,
            controller: controller.controller,
            cursorColor: Colors.white70,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onSubmitted: (text) => controller.reload(),
            decoration: InputDecoration(
                hintText: "Input nickname,UK account or email".tr,
                hintStyle: TextStyle(fontSize: 14, color: Colors.white30),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 12)),
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: GestureDetector(
                child: ImageUtil.assetImage('ic_search', width: 23.w, height: 23.w),
                onTap: () => controller.reload(),
              )),
        ],
      ),
      body: Obx(() => ListView.separated(
            itemCount: controller.list.length,
            itemBuilder: (context, index) => _item(controller.list[index]),
            separatorBuilder: (BuildContext context, int index) => Divider(),
          )),
    );
  }

  _item(SimpleUserInfoModel data) {
    return PWidget.container(
      Stack(alignment: Alignment.bottomRight, children: [
        PWidget.container(
          PWidget.row([
            Stack(alignment: Alignment.topCenter, children: [
              PWidget.container(
                CachedNetworkImage(
                    imageUrl: data.thumb ?? '', fit: BoxFit.cover, width: 74, height: 74),
                {'crr': 8},
              ),
            ]),
            PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                Flexible(
                    child: Container(
                  child: Text(
                    '${data.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  constraints: BoxConstraints(maxWidth: 100),
                )),
                PWidget.boxw(8),
                PWidget.container(
                  PWidget.row([
                    PlayLevelWidget(
                      level: '${data.userLevel}',
                      isauth: 1,
                      userId: '${data.id}',
                    ),
                    PWidget.boxw(8),
                    SexAndAgeWidget(age: '${data.age}', sex: '${data.sex}'),
                  ]),
                ),
              ]),
              PWidget.boxh(6),
              OrdersAndStarWidget(
                {'star': data.star, 'orders': data.orders},
                margin: [0],
              ),
              Wrap(
                spacing: 10,
                children: data.games
                        ?.map((e) => RawChip(
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            avatar: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                  width: 30, height: 30, imageUrl: e.ico ?? '', fit: BoxFit.cover),
                            ),
                            label: Text(
                              '${e.name}',
                              // style: TextStyle(color: Colors.blacbk38),
                            )))
                        .toList() ??
                    [],
              ),
            ], {
              'exp': 1,
            }),
          ], '001'),
          {'pd': 8},
        ),

        // locationWidget(city, data['distance']),
        // if (data['online'] == 1)
        PWidget.container(
          PWidget.text(data.online == 1 ? 'Online'.tr : 'OffLine'.tr,
              [Colors.white.withOpacity(data.online == 1 ? 1 : 0.5), 12]),
          [null, null, data.online == 1 ? Color(0xff5ADBAE) : Colors.white.withOpacity(0.1)],
          {
            'pd': PFun.lg(2, 2, 12, 12),
            'br': PFun.lg(12),
          },
        ),
      ]),
      [null, null, Color(0xff282640)],
      {
        'mg': PFun.lg(0, 0, 16, 16),
        'crr': 12,
        'fun': () {
          return Get.to(
              () => PlayDetail(userId: "${data.id}", gId: '')); //jumpPage(PlayUserInfo(data));
        }
      },
    );
  }
}
