import 'package:flutter/material.dart';

// 実装中
class DivideImageAreaPage extends StatefulWidget {
  const DivideImageAreaPage({super.key});

  @override
  State<DivideImageAreaPage> createState() => _DivideImageAreaPageState();
}

class _DivideImageAreaPageState extends State<DivideImageAreaPage> {

  Offset? _tapPosition;
  Offset? _dragStartPosition;
  Offset? _dragEndPosition;
  Offset? _dragPosition = const Offset(50.0, 50.0);

  // 縦軸初期化
  Offset? _dragPosition_x_1 = const Offset(100.0, 0.0);
  Offset? _dragPosition_x_2 = const Offset(300.0, 0.0);
  // 横軸初期化
  Offset? _dragPosition_y_1 = const Offset(0.0, 100.0);
  Offset? _dragPosition_y_2 = const Offset(0.0, 300.0);

  // 画像サイズ保持用
  final _imageKey = GlobalKey();
  Size? _imageSize;

  // 背景画像
  final Image bumperImage = Image.asset("画像のパス");








  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
