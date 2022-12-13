import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/widget/paixs_widget.dart';

class CouponItem extends StatelessWidget {
  final CouponModel model;
  final Function(CouponModel)? onTap;

  CouponItem({required this.model, this.onTap});

  img(int type) {
    var imgsrc;
    if (type <= 0 || type >= 4) {
      imgsrc = 'assets/images/coupon/1.webp';
    } else {
      imgsrc = 'assets/images/coupon/$type.webp';
    }
    switch (type) {
      case 100:
        imgsrc = 'assets/images/coupon/1.webp';
        break;
      case 101:
        imgsrc = 'assets/images/coupon/2.webp';
        break;
      case 102:
        imgsrc = 'assets/images/coupon/3.webp';
        break;
      case 103:
        imgsrc = 'assets/images/coupon/4.webp';
        break;
    }
    return imgsrc;
  }

  double mainpadding = 26.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.available == CouponModel.AVILABLE ? onTap?.call(model) : {EasyLoading.showToast('Voucher Unavailable'.tr)},
      child: Stack(
        children: [
          Container(
            height: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(img(model.type)),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(mainpadding, 16, mainpadding, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //   Spacer(),
                          Flexible(
                              flex: 7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PWidget.text('${model.discount}', [
                                    model.available == CouponModel.AVILABLE
                                        ? Colors.white
                                        : Colors.grey,
                                    50
                                  ], {
                                    'ff': 'DIN'
                                  }),
                                  if (model.unit.isNotEmpty)
                                    Container(
                                      child: Transform.rotate(
                                        angle: Math.pi / 2,
                                        child: Container(
                                            padding: EdgeInsets.only(top: 20),
                                            child: PWidget.text('${model.unit}', [
                                              model.available == CouponModel.AVILABLE
                                                  ? Colors.white
                                                  : Colors.grey,
                                              23
                                            ], {
                                              'ff': 'DIN'
                                            })),
                                      ),
                                    ),
                                ],
                              )),
                          Flexible(
                            flex: 8,
                            child: Container(
                              //    color: Colors.white60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PWidget.text('${model.typeName}', [model.available == CouponModel.AVILABLE ? Colors.yellow : Colors.grey, 25], {'ff': 'DIN'}),
                                  PWidget.text('${model.name}', [model.available == CouponModel.AVILABLE ? Colors.yellow : Colors.grey, 15], {'ff': 'DIN'}),
                                  PWidget.boxh(3),
                                  Text(
                                    '${model.description}',
                                    style: TextStyle(color: model.available == CouponModel.AVILABLE ? Colors.white70 : Colors.grey, fontSize: 14, fontFamily: 'DIN'),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          )
                          //  Spacer(),
                        ],
                      ),
                      // PWidget.text('${'Available'.tr} : ${model.expireTime}',
                      //     [Colors.white, 14], {'ff': 'DIN'})
                    ],
                  ),
                )
              ],
            ),
          ),
          if (model.usedCount > 1)
            Positioned(
              top: 15,
              right: 15,
              child: PWidget.text('${'Available'.tr} : ${model.usedCount}', [model.available == CouponModel.AVILABLE ? Colors.white : Colors.grey, 14], {'ff': 'DIN'}),
            ),
          Positioned(
            bottom: 15,
            left: mainpadding,
            // left: 20,
            child: Container(
              //    alignment: Alignment.center,
              child: PWidget.text('${'Expire Date'.tr} : ${model.expireTime}', [model.available == CouponModel.AVILABLE ? Colors.white : Colors.grey, 14], {'ff': 'DIN'}),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    // if(model.couponCode.isNotEmpty){
    //   return Text("${model.couponCode}",style: TextStyle(color: Colors.white,fontSize: 16),);
    // }
    if (model.type == 0 || model.type == 3) {
      return Text(
        "${model.discount} % ${'off'.tr}",
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    } else if (model.type == 2) {
      return Text(
        "${model.freeTime} ${'mins'.tr}",
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    }
    return Container(
      child: SizedBox(
        height: 18,
      ),
    );
  }
}
