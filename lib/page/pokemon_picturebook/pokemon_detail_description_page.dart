import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/dto/pokemon.dart';

class PokemonDetailDescriptionPage extends StatefulWidget {
  const PokemonDetailDescriptionPage({required this.pokemon, super.key});

  final Pokemon pokemon;

  @override
  State<PokemonDetailDescriptionPage> createState() =>
      _PokemonDetailDescriptionPageState();
}

class _PokemonDetailDescriptionPageState
    extends State<PokemonDetailDescriptionPage> {
  late final Pokemon _pokemon;

  final List<String> _spritesList = [];

  int _currentCarouselSliderIndex = 0;

  @override
  void initState() {
    super.initState();
    _pokemon = widget.pokemon;

    Map<String, dynamic> tmpPokemon = _pokemon.sprites as Map<String, dynamic>;
    // nullであればブランク
    _spritesList.add(tmpPokemon["front_default"] ?? "");
    _spritesList.add(tmpPokemon["back_default"] ?? "");
    _spritesList.add(tmpPokemon["other"]["showdown"]["front_default"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ポケモン詳細情報",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showDialog(context);
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
  void _showDialog(BuildContext context) {
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
