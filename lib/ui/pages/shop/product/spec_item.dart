import 'package:flutter/material.dart';

class SpecItem extends StatelessWidget {

  final String content;
  final int index;
  final int selected;
  final Function(int) onTap;

  SpecItem({
    required this.index,
    required this.content,
    required this.selected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onTap.call(index),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: Colors.white10,
          border: selected == index ? Border.all(width: 2,color: Colors.white) : Border.all(width: 2,color: Colors.transparent)
        ),
        child: Center(child: Text(content,style: TextStyle(color: Colors.white,fontSize: 14),)),
      ),
    );
  }
}