import 'package:flutter/material.dart';
import 'dart:async'; // Timer 사용을 위해 추가
import 'dart:math';

import 'main.dart';

const Color appBarToneColor = Colors.blue; // Define a constant tone color for AppBar

class CircleGame_Play extends StatefulWidget {
  const CircleGame_Play({super.key});

  @override
  State<CircleGame_Play> createState() => _CircleGame_PlayState();
}

class _CircleGame_PlayState extends State<CircleGame_Play> {
  int seekerCount = 1; // 기본 술래 수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동그라미 술래 - 설정'),
        backgroundColor: appBarToneColor, // Apply the tone color
      ),
      body: Center( // Column 위젯을 Center 위젯으로 감싸기
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 중앙 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 가로 방향으로 중앙 정렬
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // 패딩 조정
              child: Text(
                '술래 몇 명을 할까요?',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center, // 텍스트 정렬을 중앙으로 설정
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100, // 너비 설정
              height: 50, // 높이 설정
              child: DropdownButton<int>(
                isExpanded: true, // 드롭다운이 부모의 전체 너비를 차지하도록 설정
                iconSize: 30, // 드롭다운 아이콘 크기 설정
                value: seekerCount, // 현재 선택된 값 저장
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1, // 각 드롭다운 항목의 값 설정
                    child: Text(
                      '${index + 1}명',
                      style: const TextStyle(fontSize: 30), // 드롭다운 항목 텍스트의 글꼴 크기 설정
                    ),
                  ),
                ),
                onChanged: (value) { // 사용자가 새 값을 선택했을 때 호출
                  setState(() {
                    seekerCount = value!; // 선택된 값으로 상태 업데이트
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 선택된 술래 수를 사용하여 게임 로직으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CircleGameLogic(seekerCount: seekerCount),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

//실제 게임 로직
class CircleGameLogic extends StatefulWidget {
  final int seekerCount;
  const CircleGameLogic({required this.seekerCount, super.key});

  @override
  State<CircleGameLogic> createState() => _CircleGameLogicState();
}

class _CircleGameLogicState extends State<CircleGameLogic> with TickerProviderStateMixin {
  int countdown = 10;
  final Map<int, Offset> touchPositions = {}; // pointerId → 위치
  final Map<int, Color> circleColors = {}; // pointerId → 색상
  final List<Color> colors = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple,
    Colors.orange, Colors.cyan, Colors.pink, Colors.teal, Colors.lime
  ];
  final Set<int> selectedSeekers = {}; // 선택된 pointerId
  late AnimationController animationController;
  late Tween<double> sizeTween;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          selectRandomSeekers();
        });
      }
    });

    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    sizeTween = Tween<double>(begin: 60, end: 100);
  }

  void selectRandomSeekers() {
    final keys = touchPositions.keys.toList();
    keys.shuffle();
    selectedSeekers.addAll(keys.take(widget.seekerCount));
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동그라미 술래 - 게임 시작'),
      ),
      body: Listener(
        behavior: HitTestBehavior.opaque, // 터치 이벤트를 전체 화면에서 감지하도록 설정
        onPointerDown: (event) {
          if (countdown > 0) {
            setState(() {
              touchPositions[event.pointer] = event.localPosition;
              circleColors[event.pointer] = colors[event.pointer % colors.length];
            });
          }
        },
        onPointerMove: (event) {
          if (countdown > 0) {
            setState(() {
              touchPositions[event.pointer] = event.localPosition;
            });
          }
        },
        onPointerUp: (event) {
          if (countdown > 0) {
            setState(() {
              touchPositions.remove(event.pointer);
              circleColors.remove(event.pointer);
            });
          }
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      '선택된 술래 수: ${widget.seekerCount}명',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      '$countdown초',
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
              ),
              ...touchPositions.entries.map((entry) {
                final pointerId = entry.key;
                final pos = entry.value;
                final isVisible = countdown == 0
                    ? selectedSeekers.contains(pointerId)
                    : true;

                if (!isVisible) return const SizedBox.shrink(); // 숨김

                final color = circleColors[pointerId] ?? Colors.red;
                return AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final size = sizeTween.evaluate(animationController);
                    return Positioned(
                      left: pos.dx - size / 2,
                      top: pos.dy - size / 2,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              if (countdown == 0) // 카운트다운이 0일 때 버튼 표시
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 현재 술래 명수로 게임 다시 시작
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CircleGameLogic(seekerCount: widget.seekerCount),
                            ),
                          );
                        },
                        child: const Text('다시하기'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // MyHomePage로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(title: '복불복 게임'),
                            ),
                          );
                        },
                        child: const Text('다른 복불복'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}