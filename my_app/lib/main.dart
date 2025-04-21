import 'package:flutter/material.dart';
import 'package:my_app/screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        // สำหรับ AppBar
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        // สำหรับปุ่มและอื่นๆ
        useMaterial3: false,
      ),
      home: HomeScreen(),
    );
  }
}
