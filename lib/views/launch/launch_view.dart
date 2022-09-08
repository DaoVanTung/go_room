import 'package:flutter/material.dart';

class LauchView extends StatelessWidget {
  const LauchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/home.gif',
        ),
      ),
    );
  }
}
