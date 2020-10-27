import 'package:flutter/material.dart';
import '../screens/user_screen.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text('ဟင်းပွဲများ'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('ပြင်ဆင်ခြင်း'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('1'),
            onTap: () {
              // ignore: unnecessary_statements
              Null;
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_call),
            title: Text('2'),
            onTap: () {
              // ignore: unnecessary_statements
              Null;
            },
          ),
        ],
      ),
    );
  }
}
