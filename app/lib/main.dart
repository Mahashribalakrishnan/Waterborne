import 'package:flutter/material.dart';
import 'frontend/ashaworkers/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Waterborne - ASHA Worker',
      home: AshaWorkerLoginPage(),
    );
  }
}
