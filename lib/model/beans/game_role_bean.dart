import '../selector_item.dart';

class GameRoleBean extends SelectorItem {
  int id = 0;
  String name = "";
  String desc = "";

  GameRoleBean();

  @override
  String displayLabel() {
    return name;
  }

  @override
  String displayInfo() {
    return desc;
  }

  @override
  bool selectable() {
    return true;
  }

  @override
  String toString() {
    return name;
  }
}