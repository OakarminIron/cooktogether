import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/overview_screen.dart';
import 'screens/detail_screen.dart';
import 'a_Database/todb.dart';
import 'screens/user_screen.dart';
import 'screens/edit_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ToDB(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cook Together',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: OverviewScreen(),
          routes: {
            DetailScreen.routeName: (ctx) => DetailScreen(),
            UserScreen.routeName: (ctx) => UserScreen(),
            EditScreen.routeName: (ctx) => EditScreen(),
          }),
    );
  }
}
