import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardVisibilityScaffold extends StatelessWidget {
  final Widget Function(BuildContext context, bool keyboardVisible) builder;

  const KeyboardVisibilityScaffold({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
      return KeyboardDismissOnTap(
          child: builder.call(context, keyboardVisible));
    });
  }
}
