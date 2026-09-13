import 'package:flutter/material.dart';

/// Compact menus: show 5 rows, then scroll.
class LbeenaMenu {
  static const visibleItems = 5;
  static const itemHeight = kMinInteractiveDimension;
  static const maxHeight = itemHeight * visibleItems;
  static const constraints = BoxConstraints(maxHeight: maxHeight);
}
