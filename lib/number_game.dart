import 'package:flutter/material.dart';
import 'number_game_logic.dart'; // Import the logic file

const Color appBarToneColor = Colors.blue; // Define a constant tone color for AppBar

class NumberGamePage extends StatelessWidget {
  const NumberGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('숫자 끗'),
        backgroundColor: appBarToneColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '게임 설명:\n'
              '- 두 개의 숫자가 빠르게 바뀝니다.\n'
              '- \'멈추기\' 버튼을 누르면 숫자가 멈춥니다.\n'
              '- 두 숫자가 같으면 높은 등급 순서: 99 > 88 > 77 > ... > 11.\n'
              '- 다른 숫자일 경우, 두 숫자의 합이 높은 쪽이 더 높은 등급입니다.\n'
              '  예: 9+1=10 > 8+1=9.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NumberGameScreen(),
                ),
              );
            },
            child: const Text('시작하기'),
          ),
        ],
      ),
    );
  }
}
