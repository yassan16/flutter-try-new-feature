import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/constant/const_route.dart';
import 'package:flutter_try_new_feature/page/selected_panel_images_page.dart';

class FeatureListPage extends StatelessWidget {
  const FeatureListPage({super.key});

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

      body: ListView(
        children: [
          _menuItem(context,
            titleIcon: Icon(Icons.grid_on),
            mainTitle: "画像パネル選択",
            subtitle: "画像をパネル分割して、パネルを押下できるようにする",
            routePath: ConstRoute.selectImagePanelRoute,
          ),
          _menuItem(context,
            titleIcon: Icon(Icons.map),
            mainTitle: "FlutterMap",
            subtitle: "FlutterMapで位置情報を取得する",
            routePath: ConstRoute.useFlutterMapRoute,
          ),
        ],
      ),

    );
  }

  /// リストアイテム
  ///
  /// ListViewの１アイテムの項目を作成する。
  Widget _menuItem(BuildContext context, {required Icon titleIcon,
    required String mainTitle, required String subtitle, required String routePath}){

    return Container(
      decoration: new BoxDecoration(
        border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
      ),
      child:ListTile(
        leading: titleIcon,
        title: Text(
          mainTitle,
          style: TextStyle(color:Colors.black, fontSize: 18),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11,)
        ),
        onTap: () {
          Navigator.of(context).pushNamed(routePath);
        },
        onLongPress: () {
          print("onLongPress called.");
        }, // 長押し
      ),
    );

  }
}
