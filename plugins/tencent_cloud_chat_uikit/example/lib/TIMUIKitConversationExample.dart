// ignore_for_file: file_names, avoid_print
import 'package:flutter/material.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';

import 'TIMUIKitChatExample.dart';

class TIMUIKitConversationExample extends StatelessWidget {
  const TIMUIKitConversationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TIMUIKitConversation(
      onTapItem: (value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TIMUIKitChatExample(
                selectedConversation: value,
              ),
            ));
      },
    );
  }
}
