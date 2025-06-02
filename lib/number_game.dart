import 'package:flutter/material.dart';

class NumberGamePage extends StatelessWidget {
  const NumberGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('숫자 끗'),
      ),
      body: const Center(
        child: Text(
          '숫자 끗 게임 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
