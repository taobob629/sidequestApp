import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/expansion_tile.dart';

import '../model/vip_info_model.dart';

class VipBenefitItem extends StatelessWidget {
  final VipIntro model;
  final String content;
  final String title;
  final String subTitle;
  final int index;
  final int showIndex;
  final Function(int) onTap;
  final Key? key;

  VipBenefitItem({
    required this.title,
    required this.content,
    required this.index,
    required this.showIndex,
    required this.onTap,
    this.key,
    required this.subTitle,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0x77262731), Color(0x21FFF2D3)],
          )),
      child: Column(
        children: [
          ExpansionTileWidget(
            title: Row(children: [
              Image.asset(
                model.iconName,
                width: 21,
                height: 21,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  "$title",
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14.sp, fontFamily: "DIN", color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            initiallyExpanded: index == 0,
            expandViewBuilder: (anima) {
              flog(anima.status);
              return Row(
                children: [
                  // Text(
                  //   anima.isCompleted ? ' Up'.tr : 'More'.tr,
                  //   style: TextStyle(fontSize: 14, color: Colors.white),
                  // ),
                  Container(
                    width: 16,
                    height: 16,
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                    child: RotationTransition(
                      turns: anima,
                      child: bottomJtView(12, Colors.black),
                    ),
                  )
                ],
              );
            },
            onExpansionChanged: (v) => this.onTap.call(this.index),
            children: [
              Container(
                width: 1.sw,
                padding: const EdgeInsets.only(left: 39, right: 10, top: 8),
                child: Text(
                  "$content",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          Visibility(
            visible: false,
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    "Balance : ",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, color: Color(0xff808388), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "30 Minutes",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
