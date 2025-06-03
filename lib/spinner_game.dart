import 'package:flutter/material.dart'; // Flutter의 UI 구성 요소를 가져옵니다.
import 'dart:math'; // 회전 로직을 위한 수학 라이브러리를 가져옵니다.
import 'package:flutter/animation.dart'; // 애니메이션을 위한 라이브러리를 가져옵니다.

const Color appBarToneColor = Colors.blue; // AppBar의 색상을 정의합니다.

class SpinnerGamePage extends StatefulWidget {
  const SpinnerGamePage({super.key}); // StatefulWidget을 생성합니다.

  @override
  State<SpinnerGamePage> createState() => _SpinnerGamePageState(); // 상태를 관리하는 클래스 생성.
}

class _SpinnerGamePageState extends State<SpinnerGamePage>
    with SingleTickerProviderStateMixin {
  int _playerCount = 2; // 기본 플레이어 수를 2명으로 설정합니다.
  double _rotationAngle = 0; // 회전판의 회전 각도를 초기화합니다.
  late AnimationController _controller; // 애니메이션 컨트롤러를 선언합니다.
  late Animation<double> _animation; // 애니메이션 객체를 선언합니다.
  int? _winningNumber; // 당첨된 숫자를 저장합니다.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // 애니메이션의 동기화를 설정합니다.
      duration: const Duration(seconds: 5), // 애니메이션 지속 시간을 5초로 설정합니다.
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi * 10).animate(
      CurvedAnimation(
        parent: _controller, // 애니메이션 컨트롤러를 설정합니다.
        curve: Curves.easeOut, // 애니메이션이 점점 느려지도록 설정합니다.
      ),
    )..addListener(() {
        setState(() {
          _rotationAngle = _animation.value; // 애니메이션 값에 따라 회전 각도를 업데이트합니다.
        });
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final double normalizedAngle = (_rotationAngle % (2 * pi)); // 0 ~ 2π 범위로 정규화
        final double angleStep = 2 * pi / _playerCount;

        // 🔺 위쪽(12시 방향)은 -π/2 라디안
        // 회전판은 시계방향이므로 역방향으로 계산해야 정확합니다
        double adjustedAngle = (-normalizedAngle - pi / 2) % (2 * pi);
        if (adjustedAngle < 0) adjustedAngle += 2 * pi;

        final int selectedIndex = (adjustedAngle / angleStep).floor();
        _winningNumber = selectedIndex + 1; // 인덱스는 0부터 시작하므로 +1

        setState(() {});
      }
    });
  }

  void _startSpin() {
    _winningNumber = null; // 당첨된 숫자를 초기화합니다.
    final double randomSpin = Random().nextDouble() * 2 * pi * 10; // 랜덤한 회전 각도를 생성합니다.
    _animation = Tween<double>(begin: _rotationAngle, end: _rotationAngle + randomSpin).animate(
      CurvedAnimation(
        parent: _controller, // 애니메이션 컨트롤러를 설정합니다.
        curve: Curves.easeOut, // 애니메이션이 점점 느려지도록 설정합니다.
      ),
    )..addListener(() {
        setState(() {
          _rotationAngle = _animation.value; // 애니메이션 값에 따라 회전 각도를 업데이트합니다.
        });
      });

    _controller.reset(); // 애니메이션을 초기화합니다.
    _controller.forward(); // 애니메이션을 시작합니다.
  }

  @override
  void dispose() {
    _controller.dispose(); // 애니메이션 컨트롤러를 해제합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('돌림판 게임'), // AppBar의 제목을 설정합니다.
        backgroundColor: appBarToneColor, // AppBar의 배경색을 설정합니다.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 중앙 정렬합니다.
          children: [
            const Text(
              '몇명입니까?', // 사용자에게 플레이어 수를 묻는 텍스트를 표시합니다.
              style: TextStyle(fontSize: 24), // 텍스트 스타일을 설정합니다.
            ),
            const SizedBox(height: 20), // 텍스트와 DropdownButton 사이에 간격을 추가합니다.
            DropdownButton<int>(
              value: _playerCount, // 현재 선택된 플레이어 수를 표시합니다.
              items: List.generate(
                10, // 최대 10명까지 선택할 수 있도록 리스트를 생성합니다.
                (index) => DropdownMenuItem(
                  value: index + 1, // 각 항목의 값을 설정합니다.
                  child: Text('${index + 1}명'), // 각 항목의 텍스트를 설정합니다.
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _playerCount = value!; // 선택된 값을 업데이트합니다.
                });
              },
            ),
            const SizedBox(height: 20), // DropdownButton과 버튼 사이에 간격을 추가합니다.
            ElevatedButton(
              onPressed: _startSpin, // 랜덤 회전을 시작합니다.
              child: const Text('시작'), // 버튼의 텍스트를 설정합니다.
            ),
            const SizedBox(height: 20), // 버튼과 회전판 사이에 간격을 추가합니다.
            Column(
              children: [
                Icon(
                  Icons.arrow_drop_down, // 화살표 아이콘을 사용합니다.
                  size: 50, // 화살표 크기를 설정합니다.
                  color: Colors.red, // 화살표 색상을 설정합니다.
                ),
                const SizedBox(height: 10), // 화살표와 회전판 사이 간격을 추가합니다.
                Container(
                  width: 300, // 회전판의 너비를 설정합니다.
                  height: 300, // 회전판의 높이를 설정합니다.
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // 회전판을 원형으로 설정합니다.
                    border: Border.all(color: Colors.black, width: 2), // 회전판의 테두리를 설정합니다.
                  ),
                  child: CustomPaint(
                    painter: _SpinnerPainter(_playerCount, _rotationAngle), // 회전판을 그리는 페인터를 설정합니다.
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // 회전판과 결과 텍스트 사이에 간격을 추가합니다.
            if (_winningNumber != null) // 당첨된 숫자가 있을 경우에만 텍스트를 표시합니다.
              Text(
                '$_winningNumber번이 당첨되었습니다!', // 당첨된 숫자를 표시합니다.
                style: const TextStyle(fontSize: 24, color: Colors.green), // 텍스트 스타일을 설정합니다.
              ),
          ],
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final int playerCount; // 플레이어 수를 저장합니다.
  final double rotationAngle; // 회전판의 회전 각도를 저장합니다.

  _SpinnerPainter(this.playerCount, this.rotationAngle); // 생성자에서 값을 초기화합니다.

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill; // 섹션을 채우는 스타일로 설정합니다.

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke // 섹션 경계선을 그리는 스타일로 설정합니다.
      ..color = Colors.black // 경계선 색상을 검은색으로 설정합니다.
      ..strokeWidth = 2; // 경계선 두께를 설정합니다.

    final double radius = size.width / 2; // 회전판의 반지름을 계산합니다.
    final Offset center = Offset(size.width / 2, size.height / 2); // 회전판의 중심 좌표를 계산합니다.
    final double angleStep = 2 * pi / playerCount; // 각 섹션의 각도를 계산합니다.

    for (int i = 0; i < playerCount; i++) {
      final double startAngle = i * angleStep + rotationAngle; // 섹션의 시작 각도를 계산합니다.
      final double endAngle = startAngle + angleStep; // 섹션의 끝 각도를 계산합니다.

      fillPaint.color = Colors.primaries[i % Colors.primaries.length].shade300; // 섹션의 색상을 설정합니다.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), // 섹션의 영역을 설정합니다.
        startAngle, // 섹션의 시작 각도를 설정합니다.
        angleStep, // 섹션의 각도를 설정합니다.
        true, // 섹션을 채웁니다.
        fillPaint, // 섹션을 그릴 페인트를 설정합니다.
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), // 섹션의 영역을 설정합니다.
        startAngle, // 섹션의 시작 각도를 설정합니다.
        angleStep, // 섹션의 각도를 설정합니다.
        true, // 섹션 경계선을 그립니다.
        borderPaint, // 경계선을 그릴 페인트를 설정합니다.
      );

      final double textAngle = startAngle + angleStep / 2; // 텍스트의 각도를 계산합니다.
      final Offset textOffset = Offset(
        center.dx + radius * 0.7 * cos(textAngle), // 텍스트의 x 좌표를 계산합니다.
        center.dy + radius * 0.7 * sin(textAngle), // 텍스트의 y 좌표를 계산합니다.
      );

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}', // 섹션 번호를 설정합니다.
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // 텍스트 스타일을 설정합니다.
        ),
        textDirection: TextDirection.ltr, // 텍스트 방향을 설정합니다.
      )..layout();

      textPainter.paint(
        canvas,
        textOffset - Offset(textPainter.width / 2, textPainter.height / 2), // 텍스트를 중앙에 배치합니다.
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // 항상 다시 그리도록 설정합니다.
}
