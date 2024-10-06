import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/dto/move.dart';
import 'package:flutter_try_new_feature/dto/pokemon.dart';
import 'package:flutter_try_new_feature/dto/pokemon_species.dart';
import 'package:flutter_try_new_feature/model/call_pokemon_api.dart';

class PokemonDetailDescriptionPage extends StatefulWidget {
  const PokemonDetailDescriptionPage({required this.pokemon, super.key});

  final Pokemon pokemon;

  @override
  State<PokemonDetailDescriptionPage> createState() =>
      _PokemonDetailDescriptionPageState();
}

class _PokemonDetailDescriptionPageState
    extends State<PokemonDetailDescriptionPage> {
  // ポケモンのベース情報
  late final Pokemon _pokemon;
  // ポケモン画像
  final List<String> _spritesList = [];
  // モーダル画面にて選択中のindex
  int _currentCarouselSliderIndex = 0;

  late Future<PokemonSpecies> _pokemonSpeciesFuture;
  late Future<List<Move>> _movesList;

  @override
  void initState() {
    super.initState();

    _pokemon = widget.pokemon;

    Map<String, dynamic> tmpPokemon = _pokemon.sprites as Map<String, dynamic>;
    // nullであればブランク
    _spritesList.add(tmpPokemon["front_default"] ?? "");
    _spritesList.add(tmpPokemon["back_default"] ?? "");
    _spritesList.add(tmpPokemon["other"]["showdown"]["front_default"] ?? "");

    // ポケモンサブ情報を取得
    _pokemonSpeciesFuture = getPokemonSubInfo();

    // 技リストを取得
    _movesList = getMovesList();
  }

  /// ポケモンサブ情報取得
  Future<PokemonSpecies> getPokemonSubInfo() async {
    return await CallPokeApi().getPokemonSpecies(id: "${_pokemon.id}");
  }

  /// 技リスト取得
  Future<List<Move>> getMovesList() async {
    List<String> tmpMoveUrlList = _pokemon.moves
        .map((moveMap) => moveMap["move"]["url"] as String)
        .toList();

    List<Move> resultList = [];
    for (String urlStr in tmpMoveUrlList) {
      List<String> tmpList = urlStr.split("/");
      resultList
          .add(await CallPokeApi().getMove(id: tmpList[tmpList.length - 2]));
      print("${tmpList[tmpList.length - 2]}");
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
              future: _pokemonSpeciesFuture,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    PokemonSpecies species = snapshot.data;
                    return Row(
                      children: [
                        Text(
                          "No.${species.id}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          // 分類
                          "${species.genera[0]["genus"]}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  } else {
                    return const Text("noData");
                  }
                } else {
                  return const Text("読み込み中...");
                }
              }),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          // ポケモン名と画像、タイプ、種族値
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ポケモン名と画像
              Container(
                // color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(children: [
                  // 名前
                  Container(
                    // padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Text(
                      _pokemon.name,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  // 画像
                  GestureDetector(
                    onTap: () {
                      _showDialogPokemonPicture(context);
                    },
                    child: Container(
                      // nullになることはないはず
                      child: Image.network(
                        _pokemon.sprites["front_default"],
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("高さ: ${_pokemon.getHeightFromDmToM()}m"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("重さ: ${_pokemon.getWeightFromHgToKg()}kg"),
                    ],
                  ),
                ]),
              ),
              // タイプと種族値
              Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    children: [
                      // タイプ
                      Row(
                        children: [
                          for (Map<String, dynamic> typeMap in _pokemon.types)
                            Container(
                              // color: Colors.red,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(typeMap["type"]["name"]),
                            ),
                        ],
                      ),
                      // 余白
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      // 種族値
                      for (Map<String, dynamic> statMap in _pokemon.stats)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ステータス名と数値
                            Row(
                              children: [
                                Text(statMap["stat"]["name"]),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text("${statMap["base_stat"]}"),
                              ],
                            ),
                            // ステータスバー
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.4 *
                                  _pokemon.getStatRate(statMap["base_stat"]),
                              height: 10,
                              color: Colors.lightBlueAccent[100],
                            )
                          ],
                        ),

                      Row(
                        children: [
                          Text("Total"),
                          SizedBox(
                            width: 15,
                          ),
                          Text("${_pokemon.getTotalStats()}"),
                        ],
                      )
                    ],
                  ))
            ],
          ),
          // header
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: _MakeMoveDetailWidget(null, true),
          ),
          // 技のList表示
          FutureBuilder(
              future: _movesList,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Move> tmpMoveList = snapshot.data;
                  return Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                      itemCount: tmpMoveList.length,
                      itemBuilder: (context, index) {
                        return _MakeMoveDetailWidget(tmpMoveList[index], false);
                      },
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
        ]));
  }

  /// ポケモン画像のモーダル表示
  void _showDialogPokemonPicture(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // widget treeの管理下におく
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ポケモン画像のスライド
                    CarouselSlider.builder(
                        options: CarouselOptions(
                            // height: 500.0,
                            // 最初と最後のページ間の遷移
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentCarouselSliderIndex = index;
                              });
                            }),
                        itemCount: _spritesList.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            // アスペクト比を保持しながら、親ウィジェットのサイズに収める
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.network(_spritesList[itemIndex]),
                            ),
                          );
                        }),
                    // インジケータ表示 現在のインデックスを黒丸で表現
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _spritesList.map((url) {
                        int index = _spritesList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentCarouselSliderIndex == index
                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ));
          });
        });
  }

  /// 技のリスト表示
  Widget _MakeMoveDetailWidget(Move? move, bool isHeader) {
    late TextStyle styleText;
    late Color backgroundColor;

    if (isHeader) {
      styleText = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
      backgroundColor = Colors.lightBlueAccent[100]!;
    } else {
      styleText = TextStyle(color: Colors.black);
      backgroundColor = Colors.blue[50]!;
    }

    return Container(
      // 高さが制約されていない場合、エラーが発生する
      height: 50.0,
      color: backgroundColor,
      child: ListView.builder(
          // 横スクロール
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, innerIndex) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                  child: Text(
                    _getMoveDisplayText(move, innerIndex),
                    style: styleText,
                  ),
                ));
          }),

      ////////////////////////////////////
      ////////////////////////////////////
      // child: Row(
      //   children: [
      //     Container(
      //       color: Colors.red,
      //       width: MediaQuery.of(context).size.width * 0.10,
      //       child: Text(
      //         level,
      //         style: style,
      //         textAlign: TextAlign.center,
      //       ),
      //     ),
      //     Container(
      //       color: Colors.green,
      //       width: MediaQuery.of(context).size.width * 0.2,
      //       child: Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text(
      //           moveName,
      //           textAlign: TextAlign.center,
      //           style: style,
      //         ),
      //       ),
      //     ),
      //     Container(
      //       color: Colors.green,
      //       width: MediaQuery.of(context).size.width * 0.2,
      //       padding: const EdgeInsets.all(10.0),
      //       child: Text(
      //         type,
      //         style: style,
      //       ),
      //     ),
      //     Container(
      //       width: MediaQuery.of(context).size.width * 0.2,
      //       padding: const EdgeInsets.all(10.0),
      //       child: Text(
      //         damageClass,
      //         style: style,
      //       ),
      //     ),
      //     Container(
      //       width: MediaQuery.of(context).size.width * 0.2,
      //       padding: const EdgeInsets.all(10.0),
      //       child: Text(
      //         power,
      //         style: style,
      //       ),
      //     ),
      //     // Container(
      //     //   width: MediaQuery.of(context).size.width * 0.2,
      //     //   padding: const EdgeInsets.all(10.0),
      //     //   child: Text(
      //     //     pp,
      //     //     style: style,
      //     //   ),
      //     // ),
      //     // Container(
      //     //   padding: const EdgeInsets.all(10.0),
      //     //   child: Text(
      //     //     accuracy,
      //     //     style: style,
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }

  /// 技の表示内容の取得
  String _getMoveDisplayText(Move? move, int innerIndex) {
    late String level;
    late String moveName;
    late String type;
    late String damageClass;
    late String power;
    late String pp;
    late String accuracy;

    if (move != null) {
      level = _pokemon.getLevel(move).toString();
      moveName = move.names[0]["name"];
      type = move.type["name"];
      damageClass = move.damageClass["name"];
      power = (move.power != null) ? move.power.toString() : "-";
      pp = move.pp.toString();
      accuracy = (move.accuracy != null) ? move.accuracy.toString() : "-";
    } else {
      // ヘッダー項目
      level = "Lv";
      moveName = "技";
      type = "タイプ";
      damageClass = "種類";
      power = "威力";
      pp = "PP";
      accuracy = "命中率";
    }

    late String result;
    switch (innerIndex) {
      // レベル
      case 0:
        result = level;
        break;
      // 技
      case 1:
        result = moveName;
        break;
      // 技タイプ
      case 2:
        result = type;
        break;
      // 種類
      case 3:
        result = damageClass;
        break;
      // 威力
      case 4:
        result = power;
        break;
      // PP
      case 5:
        result = pp;
        break;
      // 命中率
      case 6:
        result = accuracy;
        break;
    }
    return result;
  }
}
