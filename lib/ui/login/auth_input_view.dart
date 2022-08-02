import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthInputView extends StatelessWidget {

  final String tips;
  final bool password;
  final TextInputType? keyboardType;
  final TextEditingController? editingController;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  AuthInputView({
    required this.tips,
    this.password = false,
    this.keyboardType,
    this.editingController,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(25)
      ),
      child: TextField(
        controller: editingController,
        focusNode: focusNode,
        maxLines: 1,
        keyboardType: keyboardType,
        obscureText: password,
        cursorColor: Colors.white70,
        textAlign: TextAlign.start,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: tips,
          hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 0)
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}