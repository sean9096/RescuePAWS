import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rescuepaws/provider/navigation_provider.dart';
import 'package:rescuepaws/models/navigation_item.dart';

class SidebarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    text: 'Home',
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    text: 'Inquiry',
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    text: 'Setting',
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
    //required IconData icon,
  }) {
    final color = Colors.white;

    return ListTile(title: Text(text, style: TextStyle(color: color)));
  }
}
