import 'package:flutter/material.dart';
import 'package:rescuepaws/screens/choice.dart';
import 'package:rescuepaws/screens/setting.dart';
import 'package:rescuepaws/screens/Inquiries.dart';

class SidebarWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) => Drawer(
        child: Material(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    text: 'Home',
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    text: 'Inquiry',
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    text: 'Setting',
                    onClicked: () => selectedItem(context, 3),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem(
    BuildContext context, {
    required String text,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChoicePage(),
        ));
        break;

      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Inquiries(),
        ));
        break;

      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
        break;

      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChoicePage(),
        ));
        break;
    }
  }
}
