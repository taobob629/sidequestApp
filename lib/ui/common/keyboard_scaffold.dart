import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'base_scaffold.dart';

class KeyboardScaffold extends StatelessWidget {

  final String title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;

  KeyboardScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, keyboardVisible) {
        return KeyboardDismissOnTap(
          child: BaseScaffold(
            title: title,
            actions: actions,
            body: body,
            floatingActionButton: keyboardVisible ? null : floatingActionButton,
          ),
        );
      }
    );
  }
}