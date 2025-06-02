import 'package:flutter/material.dart';

class SpinnerGamePage extends StatelessWidget {
  const SpinnerGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('돌림판 게임'),
      ),
      body: const Center(
        child: Text(
          '돌림판 게임 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
