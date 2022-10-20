// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:tim_ui_kit/ui/views/TIMUIKitSearch/tim_uikit_search.dart';
import 'package:provider/provider.dart';
import 'package:wy/ui/controller/user_controller.dart';

import 'chat.dart';

class ConversationPage extends StatefulWidget {
  final TIMUIKitConversationController conversationController;
  const ConversationPage({Key? key, required this.conversationController})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<ConversationPage> {
  late TIMUIKitConversationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.conversationController;
    _controller.model.addListener(() async {
      // log(_controller.model.totalUnReadCount.toString(), name:'_controller.model.addListener');
      getTotalUnreadMessageCount();
    });
  }

  ///获取未读邮件总数
  Future<void> getTotalUnreadMessageCount() async {
    var v2timValueCallback = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getTotalUnreadMessageCount();
    if(v2timValueCallback.code == 0){
      Get.find<UserController>().unreadMsgCount.value = v2timValueCallback.data!;
    }
  }

  void _handleOnConvItemTaped(V2TimConversation? selectedConv) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            selectedConversation: selectedConv!,
          ),
        ));
    _controller.reloadData();
    var v2timValueCallback = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getTotalUnreadMessageCount();
    if(v2timValueCallback.code == 0){
      Get.find<UserController>().unreadMsgCount.value = v2timValueCallback.data!;
    }
  }

  _clearHistory(V2TimConversation conversationItem) {
    _controller.clearHistoryMessage(conversation: conversationItem);
    getTotalUnreadMessageCount();
  }

  _pinConversation(V2TimConversation conversation) {
    _controller.pinConversation(
        conversationID: conversation.conversationID,
        isPinned: !conversation.isPinned!);
  }

  _deleteConversation(V2TimConversation conversation) {
    _controller.deleteConversation(conversationID: conversation.conversationID);
    getTotalUnreadMessageCount();
  }


  List<ConversationItemSlidablePanel> _itemSlidableBuilder(
      V2TimConversation conversationItem) {
    return [
      ConversationItemSlidablePanel(
        onPressed: (context) {
          _clearHistory(conversationItem);
        },
        backgroundColor: hexToColor("006EFF"),
        foregroundColor: Colors.white,
        label: "Clear",
        autoClose: true,
      ),
      ConversationItemSlidablePanel(
        onPressed: (context) {
          _pinConversation(conversationItem);
        },
        backgroundColor: hexToColor("FF9C19"),
        foregroundColor: Colors.white,
        label: conversationItem.isPinned! ? "UnTop" : "Top",
      ),
      ConversationItemSlidablePanel(
        onPressed: (context) {
          _deleteConversation(conversationItem);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: "Delete",
      )
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top+60,
        ),
        Expanded(
          child: TIMUIKitConversation(
            onTapItem: _handleOnConvItemTaped,
            itemSlidableBuilder: _itemSlidableBuilder,
            controller: _controller,
            emptyBuilder: () {
              return Container(
                padding: const EdgeInsets.only(top:100),
                child:const Center(
                  child: Text("No Conversation", style: TextStyle(color: Colors.white54),),
                ),
              );
            },
          ))
      ],
    );
  }
}
