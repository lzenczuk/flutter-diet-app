import 'package:flutter/material.dart';

class SimpleMenuAction {
  final String text;
  final VoidCallback onPress;

  SimpleMenuAction(this.text, this.onPress);
}

class SimpleMenu extends StatelessWidget {
  final List<SimpleMenuAction> entries;

  const SimpleMenu({Key key, this.entries = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext context) {
        var menuEntries = <PopupMenuEntry<int>>[];

        for (int index = 0; index < entries.length; index++) {
          menuEntries.add(PopupMenuItem(
            child: Text(entries[index].text),
            value: index,
          ));
        }

        return menuEntries;
      },
      onSelected: (int index) {
        entries[index].onPress();
      },
    );
  }
}