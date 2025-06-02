import 'package:flutter/material.dart';

const Color appBarToneColor = Colors.blue; // Define a constant tone color for AppBar

class NumberGamePage extends StatelessWidget {
  const NumberGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('숫자 끗'),
        backgroundColor: appBarToneColor, // Apply the tone color
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
