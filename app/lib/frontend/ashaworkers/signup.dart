import 'package:flutter/material.dart';

class AshaWorkerSignUpPage extends StatelessWidget {
  const AshaWorkerSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Sign Up Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
