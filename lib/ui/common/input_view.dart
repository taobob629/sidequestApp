import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputView extends StatelessWidget {

  final String label;
  final String tips;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  InputView({
    required this.label,
    required this.tips,
    this.textInputType = TextInputType.text,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(label, style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "DIN"),),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 15,right: 15,top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Color(0x10FFFFFF),
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              maxLines: 1,
              focusNode: focusNode,
              controller: controller,
              cursorColor: Colors.white70,
              textAlign: TextAlign.start,
              keyboardType: textInputType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onSubmitted: (text) => {},
              decoration: InputDecoration(
                hintText: tips,
                counterText: '',
                hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 8)
              ),
            ),
          )
        ],
      ),
    );
  }
}