import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/constant/const_route.dart';
import 'package:flutter_try_new_feature/feature_list_page.dart';
import 'package:flutter_try_new_feature/page/input_form_list_page.dart';
import 'package:flutter_try_new_feature/page/flutter_map_page.dart';
import 'package:flutter_try_new_feature/page/get_currentLocation_page.dart';
import 'package:flutter_try_new_feature/page/selected_panel_images_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // appBarの色をアプリ全体で統一
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          // テキストとアイコン
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '新機能の試し実装'),
      routes: {
        ConstRoute.featureListRoute : (context) => const FeatureListPage(),
        ConstRoute.selectImagePanelRoute : (context) => const SelectedImagePanelPage(),
        ConstRoute.inputFormListRoute : (context) => const InputFormListPage(),
        ConstRoute.useFlutterMapRoute : (context) => const FlutterMapPage(),
        ConstRoute.useGeolocatorRoute : (context) => const GetCurrentLocationPage(),
      },
    );
  }
}

/// 初期画面
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ConstRoute.featureListRoute);
              },
              child: const Text('新機能リスト一覧へ遷移'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
