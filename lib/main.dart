import 'package:flutter/material.dart';

void main() {
  runApp(const HelloMovieLogApp());
}

class HelloMovieLogApp extends StatelessWidget {
  const HelloMovieLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Hello MovieLog!'))),
    );
  }
}
