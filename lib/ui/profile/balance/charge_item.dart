import 'package:flutter/material.dart';
import 'package:wy/model/coin_charge_rule_model.dart';

class ChargeItem extends StatelessWidget {
  final int index;
  final CoinChargeRuleModel item;
  final bool selected;
  final Function(int idx) onTap;

  ChargeItem(
      {required this.index,
      required this.item,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: ()=>this.onTap.call(index),
      child: Container(
        padding: const EdgeInsets.only(top: 10,bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: Color(0xFFF83A01), width: 2) : Border.all(color: Colors.transparent, width: 2)
        ),
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
            Text(
              "${item.coin}",
              style: TextStyle(
                  color: Colors.yellow,
                  fontFamily: "DIN",
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "£${item.money}",
              style: TextStyle(
                  color: Colors.white, fontFamily: "DIN", fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
