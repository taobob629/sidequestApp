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
}
