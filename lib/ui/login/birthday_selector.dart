import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class BirthdaySelector extends StatelessWidget {

  final DateTime value;
  final Function? onTap;
  BirthdaySelector({
    required this.value,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onTap?.call(),
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 20,right: 20),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.year == DateTime.now().year && value.month == DateTime.now().month && value.day == DateTime.now().day
                  ? "Select Birthday" : formatDate(value, [dd, '/', mm, '/', yyyy]),
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
    );
  }
}