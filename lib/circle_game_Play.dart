import 'package:flutter/material.dart';
import 'dart:async'; // Timer 사용을 위해 추가

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
  int countdown = 10; // 초기 카운트다운 값
  final Map<int, Offset> touchPositions = {}; // 손가락 ID와 위치 저장
  final List<Color> colors = [ // 고유 색상 리스트
    Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple,
    Colors.orange, Colors.cyan, Colors.pink, Colors.teal, Colors.lime
  ];
  late AnimationController animationController;
  late Tween<double> sizeTween;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--; // 카운트다운 감소
        });
      } else {
        timer.cancel(); // 카운트다운이 0이 되면 타이머 중지
      }
    });
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복
    sizeTween = Tween<double>(begin: 50, end: 100); // 동그라미 크기 설정
  }

  @override
  void dispose() {
    animationController.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('동그라미 술래 - 게임 시작'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) { // 손가락 이동 시 호출
          setState(() {
            touchPositions[details.hashCode] = details.localPosition; // 손가락 위치 업데이트
          });
        },
        onPanEnd: (details) { // 손가락을 뗄 때 호출
          setState(() {
            touchPositions.remove(details.hashCode); // 손가락 위치 제거
          });
        },
        child: Stack(
          children: [
            Positioned(
              top: 20, // 중앙 상단 위치 설정
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    '선택된 술래 수: ${widget.seekerCount}명',
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center, // 텍스트를 중앙 정렬
                  ),
                  const SizedBox(height: 10), // 텍스트와 타이머 사이 간격 추가
                  Text(
                    '$countdown초', // 카운트다운 표시
                    style: const TextStyle(fontSize: 20, color: Colors.red), // 스타일 설정
                  ),
                ],
              ),
            ),
            ...touchPositions.entries.map((entry) {
              final fingerIndex = entry.key % colors.length; // 손가락 ID에 따라 색상 선택
              final position = entry.value;
              return AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final size = sizeTween.evaluate(animationController); // 크기 애니메이션
                  return Positioned(
                    left: position.dx - size / 2,
                    top: position.dy - size / 2,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: colors[fingerIndex].withOpacity(0.5), // 색상 설정
                        shape: BoxShape.circle, // 동그라미 모양
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}