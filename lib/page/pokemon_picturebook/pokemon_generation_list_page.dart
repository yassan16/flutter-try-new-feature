import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/constant/const_route.dart';
import 'package:flutter_try_new_feature/dto/pokemon.dart';
import 'package:flutter_try_new_feature/model/call_pokemon_api.dart';
import 'package:go_router/go_router.dart';

class PokemonGenerationListPage extends StatefulWidget {
  const PokemonGenerationListPage({super.key});

  @override
  State<PokemonGenerationListPage> createState() =>
      _PokemonGenerationListPageState();
}

class _PokemonGenerationListPageState extends State<PokemonGenerationListPage> {
  CallPokeApi callPokeApi = CallPokeApi();

  // ChoiceChip(ゲームの世代)の要素数
  late Future<int> _choiceChipCount;

  // 世代データ取得APIリスト
  List<String> _generationApiUrlList = [];

  // 選択している世代のポケモンidリスト
  // late Future<List<Pokemon>> _selectedGenePokemonList;

  // key:世代数 value:ポケモンidリスト
  late Future<Map<String, List<Pokemon>>> _genePokemonListMap;

  // 選択したChoiceChipの値
  // listの要素数は表示数と1ずれるので注意
  // 初期値は第1世代
  int _selectedChoiceChipValue = 0;

  @override
  void initState() {
    super.initState();

    // 世代数の取得
    _choiceChipCount = getGenerationApiUrl();
    // 世代ごとのポケモンリストMap
    _genePokemonListMap = getGenePokemonMap();
    // ポケモン情報のセット
    // _selectedGenePokemonList = getGenePokemonData(_selectedChoiceChipValue + 1);
  }

  /// 世代データ取得APIのURL
  Future<int> getGenerationApiUrl() async {
    // 全世代ごとのAPI呼び出しURLを取得
    var allGeneResponseJson = await callPokeApi.getALLGenerationApiUrl();

    // 世代APIをステートにセット
    for (Map urlMap in allGeneResponseJson["results"]) {
      _generationApiUrlList.add(urlMap["url"]);
    }

    // 世代数
    return allGeneResponseJson["count"];
  }

  /// 各世代Mapの作成
  ///
  /// 並列処理で各世代のポケモンデータを取得する
  Future<Map<String, List<Pokemon>>> getGenePokemonMap() async {
    List<Future<List<Pokemon>>> futures = [];
    // 並列処理する関数を準備
    for (int i = 1; i <= await _choiceChipCount; i++) {
      futures.add(getGenePokemonData(i));
    }
    // 並列処理実行
    List<List<Pokemon>> resultList = await Future.wait(futures);

    // Mapへ変換
    // key:世代数, value:ポケモンリスト
    return Map.fromIterables(
        resultList.asMap().entries.map((entry) => entry.key.toString()),
        resultList.map((pokemonList) => pokemonList));
  }

  /// 世代ごとのポケモンデータ取得
  Future<List<Pokemon>> getGenePokemonData(int geneInt) async {
    String strGeneInt = geneInt.toString();

    // 世代データ取得
    var allGene1 = await callPokeApi.getPokemonFromGeneration(strGeneInt);
    // 世代のポケモンidリスト
    List<int> tmpPokemonIdList = [];
    for (Map map in allGene1["pokemon_species"]) {
      // "/"で区切って最後のidを取得
      List<String> tmpList = map["url"].split("/");
      tmpPokemonIdList.add(int.parse(tmpList[tmpList.length - 2]));
    }
    tmpPokemonIdList.sort();

    // 世代に対するポケモン情報リスト取得
    List<Pokemon> pokemonList = [];
    for (int i in tmpPokemonIdList) {
      Map<String, dynamic> resultPokemon =
          await callPokeApi.getPokemon(id: "${i}");
      Pokemon p = Pokemon(resultPokemon);
      pokemonList.add(p);
      print(p.name);
    }
    return pokemonList;
  }

  // 世代数の選択リスト→ポケモンリストの順で取得
  // futureからfutureをネストして対応
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
        body: Center(
          // まずは世代数の選択リストを作成
          child: FutureBuilder(
              future: _choiceChipCount,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshotGeneCount) {
                if (snapshotGeneCount.connectionState == ConnectionState.done) {
                  // 世代数
                  int choiceChipCount = snapshotGeneCount.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 世代数のアイテム
                      Wrap(
                        spacing: 5.0,
                        children: List<Widget>.generate(
                          choiceChipCount,
                          (int index) {
                            int displayIndex = index + 1;
                            return ChoiceChip(
                              label: Text("第${displayIndex}世代"),
                              selected: _selectedChoiceChipValue == index,
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedChoiceChipValue = index;
                                  });
                                }
                              },
                            );
                          },
                        ).toList(),
                      ),
                      // 世代に紐づくポケモンリスト
                      FutureBuilder(
                          // future: _selectedGenePokemonList,
                          future: _genePokemonListMap,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              List<Pokemon> resultPokemonList =
                                  snapshot.data["$_selectedChoiceChipValue"];
                              // スクロールさせる
                              return Expanded(
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 10.0,
                                  children: [
                                    // ポケモンデータリスト
                                    for (Pokemon pokemon in resultPokemonList)
                                      GestureDetector(
                                        onTap: () {
                                          GoRouter.of(context).go(
                                              ConstRoute
                                                  .pokemonPictureBookDetailRoute,
                                              extra: pokemon);
                                        },
                                        child: Container(
                                          // nullになることはないはず
                                          child: Image.network(
                                              pokemon.sprites["front_default"]),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              // 読み込み中インジケーターを表示させる
                              return const Center(
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }),
                    ],
                  );
                } else {
                  return const Text("読み込み中...");
                }
              }),
        ));
  }
}
