import 'package:cooktogether/a_Database/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/overview_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/user_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/auth_screen.dart';
import 'a_Database/todb.dart';
import 'a_Database/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
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
          home: AuthScreen(),
          routes: {
            OverviewScreen.routeName: (ctx) => OverviewScreen(),
            DetailScreen.routeName: (ctx) => DetailScreen(),
            UserScreen.routeName: (ctx) => UserScreen(),
            EditScreen.routeName: (ctx) => EditScreen(),
          }),
    );
  }
}
