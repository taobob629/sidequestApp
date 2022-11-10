import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/coupon_model.dart';

class CouponItem extends StatelessWidget {

  final CouponModel model;
  final Function(CouponModel)? onTap;

  CouponItem({required this.model,this.onTap});

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


    return GestureDetector(
      onTap: ()=>onTap?.call(model),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_coupon.webp"),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colors[model.type]
          ),
          child: Stack(
            children: [
              Positioned(
                left: -9,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: AppColor.background,
                      borderRadius: BorderRadius.circular(9)
                    ),
                  ),
                )
              ),
              Positioned(
                right: -9,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: AppColor.background,
                      borderRadius: BorderRadius.circular(9)
                    ),
                  ),
                )
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${model.name}",style: TextStyle(color: Colors.white,fontSize: 16),),
                      _buildDisplay()
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 5.0),
                  //   child: Text("${model.couponCode}",style: TextStyle(color: Colors.white,fontSize: 16),),
                  // ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.widgets_outlined,size: 16, color: Colors.white,),
                            SizedBox(width: 5,),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                model.typeName,
                                style: TextStyle(fontSize: 16,fontFamily: "DIN",color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Text(
                          "${'Expire Date'.tr}: ${model.expireTime}",
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay(){
    // if(model.couponCode.isNotEmpty){
    //   return Text("${model.couponCode}",style: TextStyle(color: Colors.white,fontSize: 16),);
    // }
    if(model.type == 0 || model.type == 3){
      return Text(
        "${model.discount} % ${'off'.tr}",
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    }else if(model.type == 2){
      return Text(
        "${model.freeTime} ${'mins'.tr}",
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    }
    return Container(
      child: SizedBox(height: 18,),
    );
  }
}