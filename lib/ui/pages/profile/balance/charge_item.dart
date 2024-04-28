import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../model/chage_rule_model.dart';
import '../../../../widget/paixs_widget.dart';

class ChargeItem extends StatelessWidget {
  final int index;
  final CoinChargeRuleModel item;
  final bool selected;
  final bool showCoin;
  final Function(int idx) onTap;

  ChargeItem({
    required this.index,
    required this.item,
    required this.selected,
    this.showCoin = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => this.onTap.call(index),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: showCoin ? 6.0 : 10.0,
              bottom: showCoin ? 6.0 : 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(color: Color(0xFFF83A01), width: 2)
                  : Border.all(
                      color: Colors.transparent,
                      width: 2,
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  showCoin
                      ? "assets/images/ic_coin_charge${index + 1}.webp"
                      : "assets/images/ic_balance_charge${index + 1}.webp",
                  width: showCoin ? 50 : 60,
                ),
                Visibility(
                    visible: showCoin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: PWidget.image(
                            'assets/images/ic_balance_money.webp',
                            [20, 20],
                          ),
                        ),
                        Text(
                          " ${item.coin}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.freeCoin > 0) ...[
                          Text(
                            "+",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${item.freeCoin}",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )
                        ]
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Visibility(
                    //     visible: item.money != item.actualMoney,
                    //     child: Text(
                    //       "£${item.actualMoney}",
                    //       style: TextStyle(
                    //           color: Colors.white54,
                    //           fontSize: 18,
                    //           decoration: TextDecoration.lineThrough,
                    //           decorationThickness: 1,
                    //           decorationColor: Colors.white54,
                    //           decorationStyle: TextDecorationStyle.solid),
                    //     )),
                    // PWidget.boxw(3),
                    Text(
                      "£${item.money}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Visibility(
              visible: item.give > 0 && showCoin,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/charge_badge.png"))),
                child: Transform.rotate(
                  angle: pi / 4,
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${item.give}%UP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
