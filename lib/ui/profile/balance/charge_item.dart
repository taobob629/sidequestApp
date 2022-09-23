import 'package:flutter/material.dart';
import 'package:wy/model/chage_rule_model.dart';
import 'package:wy/widget/paixs_widget.dart';

class ChargeItem extends StatelessWidget {
  final int index;
  final CoinChargeRuleModel item;
  final bool selected;
  final bool showCoin;
  final Function(int idx) onTap;

  ChargeItem(
      {required this.index,
      required this.item,
      required this.selected,
      this.showCoin = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => this.onTap.call(index),
      child: Container(
        padding: const EdgeInsets.only(top: 6, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: selected
                ? Border.all(color: Color(0xFFF83A01), width: 2)
                : Border.all(color: Colors.transparent, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/ic_balance_charge${index + 1}.webp",
              width: 50,
            ),
            SizedBox(
              height: 2,
            ),
            Visibility(
                visible: showCoin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PWidget.image('assets/images/ic_balance_money.webp', [16, 16]),
                    Text(
                      " ${item.coin}",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontFamily: "DIN",
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            Text(
              "£${item.money}",
              style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
