import 'package:meme_hub/config/palette.dart';
import 'package:meme_hub/responsive.dart';
import 'package:meme_hub/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Palette.scaffold,
        primarySwatch: Colors.blue,
      ),
      home: const LoadingPage(),
    );
  }
}
