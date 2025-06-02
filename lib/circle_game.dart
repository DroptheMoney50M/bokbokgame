import 'package:flutter/material.dart';

import 'circle_game_Play.dart';

const Color appBarToneColor = Colors.blue; // Define a constant tone color for AppBar

class CircleGamePage extends StatelessWidget {
  const CircleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동그라미 술래'),
        backgroundColor: appBarToneColor, // Apply the tone color
      ),
      body: Center( // Wrap Column with Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '동그라미 술래 게임은 여러 손가락으로 화면을 누르고, 술래를 선택하는 재미있는 게임입니다!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the  next step
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CircleGame_Play()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('게임 시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
