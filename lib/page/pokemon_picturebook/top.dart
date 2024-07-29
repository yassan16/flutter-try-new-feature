import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/model/call_pokemon_api.dart';

class PokemonPictureBookTop extends StatefulWidget {
  const PokemonPictureBookTop({super.key});

  @override
  State<PokemonPictureBookTop> createState() => _PokemonPictureBookTopState();
}


class _PokemonPictureBookTopState extends State<PokemonPictureBookTop> {

  String _imageUrl1 = "";
  String _imageUrl2 = "";
  String _imageUrl3 = "";

  @override
  void initState() {
    super.initState();
    // ここに非同期処理を入れると初期画面でステートを適応できる
  }

  /// ポケモン画像取得
  Future<void> callAPI() async {
    var imageUrl1 = await CallPokeApi().getPokemon(id: "1");
    var imageUrl2 = await CallPokeApi().getPokemon(id: "4");
    var imageUrl3 = await CallPokeApi().getPokemon(id: "7");

    // 非同期処理が完了する前にウィジェットが破棄された場合（例: ユーザーが画面を移動した場合）、
    // setStateが呼び出されるとエラーが発生するため、Widgetの存在確認をする
    if(mounted){
      // 上記の非同期が完了してから
      setState(() {
        _imageUrl1 = imageUrl1;
        _imageUrl2 = imageUrl2;
        _imageUrl3 = imageUrl3;
      });
    }
  }

  void clearUrl(){
    setState(() {
      _imageUrl1 = "";
      _imageUrl2 = "";
      _imageUrl3 = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_imageUrl1.isNotEmpty)
                Image.network(_imageUrl1),
              if(_imageUrl2.isNotEmpty)
                Image.network(_imageUrl2),
              if(_imageUrl3.isNotEmpty)
                Image.network(_imageUrl3),
            ],
          ),

          ElevatedButton(
            onPressed: callAPI,
            child: Text("get"),
          ),
          ElevatedButton(
            onPressed: clearUrl,
            child: Text("clear"),
          ),
        ],
        ),
      ),

    );
  }
}
