import 'package:flutter/material.dart';

class _SectionEntry {
  final String name;
  final String path;
  final Widget icon;

  const _SectionEntry(this.name, this.path, this.icon);
}

class MainDrawer extends StatelessWidget {
  final String active;
  final List<_SectionEntry> _selections = const [
    _SectionEntry("Products", "/", Icon(Icons.shopping_basket)),
    _SectionEntry("Recipes", "/recipes", Icon(Icons.assignment)),
  ];

  const MainDrawer({Key key, this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = _buildSections(context);
    Widget header = _buildHeader(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          header,
          ...sections,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextStyle headerStyle = TextStyle(
        fontStyle: themeData.textTheme.headline.fontStyle,
        fontFamily: themeData.textTheme.headline.fontFamily,
        fontSize: themeData.textTheme.headline.fontSize,
        fontWeight: themeData.textTheme.headline.fontWeight,
        color: Colors.white);

    Widget header = DrawerHeader(
      child: Text(
        "Diet app",
        style: headerStyle,
      ),
      decoration: BoxDecoration(color: themeData.primaryColor),
    );
    return header;
  }

  List<Widget> _buildSections(BuildContext context) {
    return this._selections.map((se){
      if (se.name == active) {
        return ListTile(
          title: Text(se.name, style: TextStyle(fontWeight: FontWeight.bold)),
          leading: se.icon,
        );
      } else {
        return ListTile(
          title: Text(se.name),
          leading: se.icon,
          onTap: () => Navigator.pushNamed(context, se.path),
        );
      }
    }).toList(growable: false);
  }
}
