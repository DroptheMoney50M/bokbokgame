import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const Color appBarToneColor = Colors.blue;

class NumberGameScreen extends StatefulWidget {
  const NumberGameScreen({super.key});

  @override
  State<NumberGameScreen> createState() => _NumberGameScreenState();
}

class _NumberGameScreenState extends State<NumberGameScreen> {
  final Random _random = Random();
  int _leftNumber = 0;
  int _rightNumber = 0;
  bool _isRunning = false;
  List<String> _records = [];
  Timer? _timer;

  void _startGame() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        _leftNumber = _random.nextInt(10);
        _rightNumber = _random.nextInt(10);
      });
    });
  }

  void _stopGame() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _records.add('$_leftNumber$_rightNumber');
      _leftNumber = 0; // Reset left number
      _rightNumber = 0; // Reset right number
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '$_leftNumber$_rightNumber',
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? _stopGame : _startGame,
                child: Text(_isRunning ? '멈춤' : '시작하기'),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                childAspectRatio: 3, // Adjust the height-to-width ratio
              ),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      '${index + 1}번: ${_records[index]}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final List<String> records;

  const ResultsScreen({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결과'),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${index + 1}번: ${records[index]}'),
          );
        },
      ),
    );
  }
}
