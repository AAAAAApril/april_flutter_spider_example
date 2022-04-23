import 'package:april/april.dart';
import 'package:books/pages/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: WillPopScope(
        onWillPop: () async {
          ///回退到桌面
          April.backToDesktop();
          return false;
        },
        child: const MainPage(),
      ),
    );
  }
}
