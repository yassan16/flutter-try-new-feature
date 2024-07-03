import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/page/selected_panel_images_page.dart';

class NewFeatureListPage extends StatelessWidget {
  const NewFeatureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '機能一覧',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectedPanelImagesPage(),
                  ),
                );
              },
              child: const Text('画像パネル選択'),
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
