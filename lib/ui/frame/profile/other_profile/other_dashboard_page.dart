import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/utils/index.dart';

import 'other_profile_page.dart';

class OtherDashboardPage extends StatelessWidget {
  const OtherDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = OtherProfileController.find;
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
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
                  .map((game) => Container(
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                        padding: EdgeInsets.only(right: 10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xFF292F3F)),
                        child: Row(
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
                                              Text("Services", style: TextStyle(fontSize: 14, color: Colors.white)),
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
                                        Container(
                                          width: 52,
                                          height: 26,
                                          margin: EdgeInsets.only(bottom: 13),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(13),
                                            color: AppColor.yellow,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Play",
                                            style: TextStyle(fontSize: 12, color: AppColor.tabBackGround, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
