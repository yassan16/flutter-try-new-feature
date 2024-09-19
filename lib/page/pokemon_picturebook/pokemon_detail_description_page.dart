import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  }

  /// ポケモンサブ情報取得
  Future<PokemonSpecies> getPokemonSubInfo() async {
    return await CallPokeApi().getPokemonSpecies(id: "${_pokemon.id}");
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
                  return Column(
                    children: [
                      Text(
                        "No.${species.id}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
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
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showDialogPokemonPicture(context);
            },
            child: Container(
              // nullになることはないはず
              child: Image.network(_pokemon.sprites["front_default"]),
            ),
          ),
        ],
      ),
    );
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
}
