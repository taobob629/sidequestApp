import '../selector_item.dart';

class GameRoleBean extends SelectorItem {
  int id = 0;
  String name = "";
  String desc = "";
  bool setGrey = true;

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
    return setGrey;
  }

  @override
  String toString() {
    return name;
  }
}