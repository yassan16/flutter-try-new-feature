
import 'package:flutter/material.dart';

class SelectedPanelImagesPage extends StatefulWidget {
  const SelectedPanelImagesPage({super.key});


  @override
  State<SelectedPanelImagesPage> createState() => _SelectedPanelImagesPage();
}

class _SelectedPanelImagesPage extends State<SelectedPanelImagesPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),

      body: Center(
        child: Column(
          children: [
            Container(
              width: 200,
              child: Image.asset('assets/images/demons_souls.jpeg'),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
