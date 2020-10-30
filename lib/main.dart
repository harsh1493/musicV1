import 'package:flutter/material.dart';
import 'package:music/first_screen.dart';
import 'package:music/second_screen.dart';
import 'loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light()
          .copyWith(appBarTheme: AppBarTheme(color: Colors.white)),
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        FirstScreen.id: (context) => FirstScreen(),
        SecondScreen.id: (context) => SecondScreen(),
      },
    );
  }
}
