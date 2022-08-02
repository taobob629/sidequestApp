import 'package:flutter/material.dart';

class ChargeItem extends StatelessWidget {
  final int index;
  final int num;
  final bool selected;
  final Function(int idx) onTap;

  ChargeItem({
    required this.index,
    required this.num,
    required this.selected,
    required this.onTap
  });

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
            Image.asset("assets/images/ic_balance_charge${index+1}.webp",width: 60,),
            Text("£$num", style: TextStyle(color: Colors.white,fontFamily: "DIN",fontSize: 26),)
          ],
        ),
      ),
    );
  }
}