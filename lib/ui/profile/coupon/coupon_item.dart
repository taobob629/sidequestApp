import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/utils/utils.dart';
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

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [];
    colors.add(Color(0x77F89A08));
    colors.add(Color(0x77FC3C02));
    colors.add(Color(0x775B3E98));
    colors.add(Color(0x77FCB013));
    colors.add(Color(0x77841FC3));
    colors.add(Color(0x7719AD74));
    colors.add(Color(0x773967D9));
    colors.add(Color(0x77FC6D13));
    colors.add(Color(0x77669EFC));
    colors.add(Color(0x77CF5DA6));
    flog('model.type ${model.type}');
    return GestureDetector(
      onTap: () => onTap?.call(model),
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
                  padding: EdgeInsets.fromLTRB(45, 16, 45, 16),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(12),
                  //     color: colors[model.type]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //   Spacer(),
                          Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PWidget.text('${model.discount}',
                                      [Colors.white, 60], {'ff': 'DIN'}),
                                  if (model.unit.isNotEmpty)
                                    Container(
                                      child: Transform.rotate(
                                        angle: Math.pi / 2,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 18, right: 6),
                                            child: PWidget.text(
                                                '${model.unit}',
                                                [Colors.white, 30],
                                                {'ff': 'DIN'})),
                                      ),
                                    ),
                                ],
                              )),
                          PWidget.boxw(10),
                          Flexible(
                            flex: 4,
                            child: Container(
                              //    color: Colors.white60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PWidget.text('${model.typeName}',
                                      [Colors.yellow, 25], {'ff': 'DIN'}),
                                  PWidget.text('${model.name}',
                                      [Colors.yellow, 16], {'ff': 'DIN'}),
                                  PWidget.text('${model.description}',
                                      [Colors.yellow, 17], {'ff': 'DIN'}),
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
            // child: Container(
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(12),
            //       color: colors[model.type]),
            //   child: Stack(
            //     children: [
            //       Positioned(
            //           left: -9,
            //           top: 0,
            //           bottom: 0,
            //           child: Center(
            //             child: Container(
            //               height: 18,
            //               width: 18,
            //               decoration: BoxDecoration(
            //                   color: AppColor.background,
            //                   borderRadius: BorderRadius.circular(9)),
            //             ),
            //           )),
            //       Positioned(
            //           right: -9,
            //           top: 0,
            //           bottom: 0,
            //           child: Center(
            //             child: Container(
            //               height: 18,
            //               width: 18,
            //               decoration: BoxDecoration(
            //                   color: AppColor.background,
            //                   borderRadius: BorderRadius.circular(9)),
            //             ),
            //           )),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Text(
            //                 "${model.name}",
            //                 style: TextStyle(color: Colors.white, fontSize: 16),
            //               ),
            //               _buildDisplay()
            //             ],
            //           ),
            //           // Padding(
            //           //   padding: const EdgeInsets.only(top: 5.0),
            //           //   child: Text("${model.couponCode}",style: TextStyle(color: Colors.white,fontSize: 16),),
            //           // ),
            //           SizedBox(
            //             height: 15,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.only(left: 15),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Row(
            //                   children: [
            //                     Icon(
            //                       Icons.widgets_outlined,
            //                       size: 16,
            //                       color: Colors.white,
            //                     ),
            //                     SizedBox(
            //                       width: 5,
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.only(top: 6),
            //                       child: Text(
            //                         model.typeName,
            //                         style: TextStyle(
            //                             fontSize: 16,
            //                             fontFamily: "DIN",
            //                             color: Colors.white),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //                 Text(
            //                   "${'Expire Date'.tr}: ${model.expireTime}",
            //                   style: TextStyle(fontSize: 12, color: Colors.white60),
            //                 )
            //               ],
            //             ),
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // ),
          ),
          if (model.usedCount > 1)
            Positioned(
              top: 15,
              right: 15,
              child: PWidget.text('${'Available'.tr} : ${model.usedCount}',
                  [Colors.white, 14], {'ff': 'DIN'}),
            ),
          Positioned(
            bottom: 15,
            left: 60,
            // left: 20,
            child: Container(
              //    alignment: Alignment.center,
              child: PWidget.text('${'Expire Date'.tr} : ${model.expireTime}',
                  [Colors.white, 14], {'ff': 'DIN'}),
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
