
import 'package:flutter/material.dart';

class SelectedImagePanelPage extends StatefulWidget {
  const SelectedImagePanelPage({super.key});


  @override
  State<SelectedImagePanelPage> createState() => _SelectedImagePanelPage();
}

class _SelectedImagePanelPage extends State<SelectedImagePanelPage>  with SingleTickerProviderStateMixin {

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final _animation = _controller.drive(Tween<double>(begin: 1, end: 0.95));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),

      body: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.green,
          ),
          // 重ねて表示できる
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/demons_souls.jpeg'),
              ),
              // ボックスパネル
              makeBoxPanel(),
            ]
          ),

        ],
      ),
    );
  }

  Widget makeBoxPanel(){
    return
      Container(
        child: Column(
          children: [
            Row(
              children: [
                makeBoxPanelParts(),
                makeBoxPanelParts(),
                makeBoxPanelParts(),
                makeBoxPanelParts(),
              ],
            ),
            Row(
              children: [
                makeBoxPanelParts(),
                makeBoxPanelParts(),
                makeBoxPanelParts(),
                makeBoxPanelParts(),
              ],
            ),
          ],
        )
      );
  }

  Widget makeBoxPanelParts(){
    return
      GestureDetector(
        onTap: () {
          
        },
        child: Container(
          width: 98,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ScaleTransition(
            scale: _animation,
            // child: widget.child,
          ),
        ),
              onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      );

  }
}
