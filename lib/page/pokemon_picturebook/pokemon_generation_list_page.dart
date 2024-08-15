import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/constant/const_route.dart';
import 'package:flutter_try_new_feature/model/call_pokemon_api.dart';
import 'package:go_router/go_router.dart';

class PokemonGenerationListPage extends StatefulWidget {
  const PokemonGenerationListPage({super.key});

  @override
  State<PokemonGenerationListPage> createState() => _PokemonGenerationListPageState();
}


class _PokemonGenerationListPageState extends State<PokemonGenerationListPage> {

  CallPokeApi callPokeApi = CallPokeApi();

  // ChoiceChip(ゲームの世代)の要素数
  int? _choiceChipCount;

  // 世代データ取得APIリスト
  List<String> _generationApiUrlList = [];

  // 選択している世代のポケモンidリスト
  // key:世代数 value:ポケモンidリスト
  Map<String, List<Map>> _selectedGenePokemonIdListMap = {};

  // 選択したChoiceChipの値
  // listの要素数は表示数と1ずれるので注意
  // 初期値は第1世代
  int? _selectedChoiceChipValue = 0;

  @override
  void initState(){
    super.initState();
  }

  /// 表示ポケモンデータの取得
  ///
  /// FutureBuilder の呼び出しで使用する
  Future<List> getDisplayPokemonData(int geneInt) async {

    // nullなら世代数をセット
    _choiceChipCount ??= await getGenerationApiUrl();

    // 世代ポケモンデータの取得
    return await getGenePokemonData(geneInt);

  }

  /// 世代データ取得APIのURL
  Future<int> getGenerationApiUrl() async {

    // 全世代ごとのAPI呼び出しURLを取得
    var allGeneResponseJson  = await callPokeApi.getALLGenerationApiUrl();

    // 世代APIをステートにセット
    // Listの要素数を世代数として管理
    for (Map urlMap in allGeneResponseJson["results"]) {
      _generationApiUrlList.add(urlMap["url"]);
    }

    // 世代数
    return allGeneResponseJson["count"];

  }

  /// 世代ごとのポケモンデータ取得
  Future<List> getGenePokemonData(int geneInt) async {

    String strGeneInt = geneInt.toString();

    // Mapに既存の世代ポケモンデータが存在しない場合は、取得処理を実行する
    if(_selectedGenePokemonIdListMap[strGeneInt] == null){
      // 世代データ取得
      var allGene1 = await callPokeApi.getPokemonFromGeneration(strGeneInt);
      // 世代のポケモンidリスト
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
      // 世代ごとにMapに保存する
      _selectedGenePokemonIdListMap[strGeneInt] = tmpList;
    }

    return _selectedGenePokemonIdListMap[strGeneInt]!;
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
        future: getDisplayPokemonData(_selectedChoiceChipValue! + 1),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children = [];
          // 世代選択
          children.add(
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                // 世代数 nullの場合は1
                _choiceChipCount ??= 1,
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
            List<Map> resultMapList = snapshot.data;
            children.add(
              // スクロールさせる
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    // ポケモンデータリスト
                    for(Map tmpMap in resultMapList)
                      GestureDetector(
	                      onTap: () {
	                        GoRouter.of(context).go(ConstRoute.pokemonPictureBookDetailRoute);
	                      },
                        child: Container(
                          child: Image.network(tmpMap["sprites"]["front_default"]),
                      ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            // 読み込み中インジケーターを表示させる
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
