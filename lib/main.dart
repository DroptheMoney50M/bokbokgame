import 'package:flutter/material.dart';
import 'circle_game.dart';
import 'spinner_game.dart';
import 'number_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '복불복 게임',),  );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CircleGamePage()),
                );
              },
              child: const Text(
                '동그라미 술래',
                style: TextStyle(fontSize: 30),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 100),
                textStyle: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpinnerGamePage()),
                );
              },
              child: const Text(
                '돌림판',
                style: TextStyle(fontSize: 30),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 100),
                textStyle: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumberGamePage()),
                );
              },
              child: const Text(
                '숫자 끗',
                style: TextStyle(fontSize: 30),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 100),
                textStyle: const TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
