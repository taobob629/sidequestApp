import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/order/detail/widgets/acticon_widget.dart';
import 'package:wy/utils/index.dart';

import 'other_profile_page.dart';

class OtherDashboardPage extends StatelessWidget {
  const OtherDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = OtherProfileController.find;
    return Obx(() => ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [Text("Badge", style: TextStyle(fontSize: 14, color: Colors.white))],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 1,
                      children: t.player.value.trophies.map((e) => ImageUtil.networkImage(url: e.iconImage)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [Text("Services", style: TextStyle(fontSize: 14, color: Colors.white))],
                    ),
                  ),
                  ...t.player.value.games
                      .map((game) => GestureDetector(
                            onTap: () {
                              t.selGame.value = game;
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                              padding: EdgeInsets.only(right: 10),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xFF292F3F)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 12),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                          child: ImageUtil.networkImage(url: game.thumb, width: 96, height: 90, fit: BoxFit.cover)),
                                      Expanded(
                                          child: SizedBox(
                                        height: 90,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(game.name, style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                                    Row(
                                                      children: [
                                                        if (game.serviceItem.isNotEmpty) ...[
                                                          Image(
                                                            image: AssetImage('assets/images/ic_balance_money.webp'),
                                                            width: 15,
                                                            height: 15,
                                                          ),
                                                          3.horizontalSpace,
                                                          Text("${double.tryParse(game.serviceItem.first.price)}", style: TextStyle(fontSize: 14, color: Colors.white)),
                                                        ]
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: AppColor.yellow,
                                                          size: 11,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          game.star.toString(),
                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  EditPlayBtn(
                                                    isEdit: t.isSelf,
                                                    onTap: () {
                                                      t.selGame.value = game;
                                                    },
                                                  ).marginOnly(bottom: 13)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                  if (t.selGame.value == game) ...[
                                    ...game.serviceItem.map((service) {
                                      return Container(
                                        height: 44,
                                        decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColor.itemBg, width: 1))),
                                        padding: EdgeInsets.only(left: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(service.name, style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Image(
                                                  image: AssetImage('assets/images/ic_balance_money.webp'),
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                3.horizontalSpace,
                                                Text("${double.tryParse(service.price)}", style: TextStyle(fontSize: 14, color: Colors.white)),
                                                10.horizontalSpace,
                                                EditPlayBtn(
                                                  isEdit: t.isSelf,
                                                  onTap: () {
                                                    t.editService(game, service);
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    })
                                  ]
                                ],
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          ],
        ));
  }
}

class EditPlayBtn extends StatelessWidget {
  EditPlayBtn({Key? key, this.isEdit = false, this.onTap}) : super(key: key);
  bool isEdit = false;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: 52,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: AppColor.yellow,
        ),
        alignment: Alignment.center,
        child: Text(
          isEdit ? "Edit" : "Play",
          style: TextStyle(fontSize: 12, color: AppColor.tabBackGround, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
