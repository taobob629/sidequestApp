import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class BirthdayEditor extends StatelessWidget {

  final String label;
  final DateTime value;
  final Function? onTap;
  BirthdayEditor({
    required this.label,
    required this.value,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onTap?.call(),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(label, style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "DIN"),),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0x10FFFFFF),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value.year == DateTime.now().year && value.month == DateTime.now().month && value.day == DateTime.now().day
                        ? "Select your birthday" : formatDate(value, [dd, '/', mm, '/', yyyy]),
                      style: TextStyle(
                        color: value.year == DateTime.now().year ? Colors.white24 : Colors.white,
                        fontSize: 14
                      ),
                    )
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,color: Colors.white, size: 20,)
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}