import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/model/call_pokemon_api.dart';

class PokemonPictureBookTop extends StatefulWidget {
  const PokemonPictureBookTop({super.key});

  @override
  State<PokemonPictureBookTop> createState() => _PokemonPictureBookTopState();
}


class _PokemonPictureBookTopState extends State<PokemonPictureBookTop> {

  CallPokeApi callPokeApi = CallPokeApi();

  // ChoiceChip(ゲームの世代)の要素数
  late int _choiceChipCount;

  // 世代データ取得APIリスト
  List<String> _generationApiUrlList = [];

  // 選択している世代のポケモンidリスト
  // key:世代数 value:ポケモンidリスト
  Map<String, List<Map>> _selectedGenePokemonIdListMap = {};

  // listの要素数は表示数と1ずれるので注意
  // 選択したChoiceChipの値
  int? _selectedChoiceChipValue = 0;

  @override
  void initState(){
    super.initState();
    // ここに非同期処理を入れると初期画面でステートを適応できる

    getGenerationApiUrl();

  }

  Future<void> getGenerationApiUrl() async {

    // 全世代ごとのAPI呼び出しURLを取得
    var allGeneResponseJson  = await callPokeApi.getALLGenerationApiUrl();
    print("===");
    print(allGeneResponseJson);

    // 世代数をセット
    _choiceChipCount = allGeneResponseJson["count"];

    // 世代APIをステートにセット
    // Listの要素数を世代数として管理
    for (Map urlMap in allGeneResponseJson["results"]) {
      _generationApiUrlList.add(urlMap["url"]);
    }
    print("===");
    print(_generationApiUrlList);

  }

  Future<Map> getInitGenePokemonData(int geneInt) async {
    // 世代１のポケモン画像を初期データとして読み込む
    var allGene1 = await callPokeApi.getPokemonFromGeneration("${geneInt}");
    List<int> tmpResultList = [];
    for (Map map in allGene1["pokemon_species"]) {
      // "/"で区切って最後のidを取得
      List<String> tmpList = map["url"].split("/");
      tmpResultList.add(int.parse(tmpList[tmpList.length - 2]));
    }
    tmpResultList.sort();

    // 世代マップとポケモンの紐付け
    List<Map> tmpList = [];
    for(int i in tmpResultList) {
      tmpList.add(await callPokeApi.getPokemon(id: "${i}"));
    }
    print("===");
    print("${tmpList[0]["id"]} :${tmpList[0]["name"]}");
    _selectedGenePokemonIdListMap["1"] = tmpList;

    return _selectedGenePokemonIdListMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ポケモン図鑑",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getInitGenePokemonData(_selectedChoiceChipValue! + 1),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children = [];
          // 世代選択
          children.add(
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                // TODO 世代取得APIのcount数にする
                9,
                (int index) {
                  int displayIndex = index + 1;
                  return ChoiceChip(
                    label: Text('Item $displayIndex'),
                    selected: _selectedChoiceChipValue == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedChoiceChipValue = selected ? index : null;
                      });
                    },
                  );
                },
              ).toList(),
            ),
          );
          // データの有無によりWidgetを切り替え
          if(snapshot.connectionState == ConnectionState.done){
            Map<String, List<Map>> resultMap = snapshot.data;
            children.add(
              // スクロールさせる
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    for(Map tmpMap in resultMap["1"]!)
                      Container(
                        child: Image.network(tmpMap["sprites"]["front_default"]),
                      ),
                  ],
                ),
              ),
            );
          } else {
            children.add(
              const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              )
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },

      ),
    );
  }
}
