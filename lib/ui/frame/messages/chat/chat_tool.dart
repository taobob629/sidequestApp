import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../../utils/utils.dart';

class ChatTool {
  ChatTool._();

  /// 特殊渠道可在此添加屏蔽用户userId
  static final converFilters = ["sq_hide_notify"];

  /// 通过id 筛选会话
  static bool converFilter(userId) {
    if (userId == null) {
      return false;
    }
    return !converFilters.contains(userId);
  }

  ///获取未读数量
  static Future<int> getUnreadMsgCount() async {
    var unreadMsgCount = 0;
    var v2timValueCallback = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getTotalUnreadMessageCount();
    if (v2timValueCallback.code == 0) {
      flog(v2timValueCallback.data, 'getTotalUnreadMessageCount');
      unreadMsgCount = v2timValueCallback.data!;
      FlutterAppBadger.isAppBadgeSupported().then((value) {
        if (unreadMsgCount == 0) {
          FlutterAppBadger.removeBadge();
        } else {
          flog(value, 'getTotalUnreadMessageCount');
          FlutterAppBadger.updateBadgeCount(unreadMsgCount, title: 'New Message');
        }
      });
    }
    return unreadMsgCount;
  }
}
