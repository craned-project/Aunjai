import 'package:aunjai/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Color(0xff09101f),
          theme: ThemeData(
            fontFamily: 'IBM', // Sets it globally
          ),
          home: HomePage(),
        );
    }
}