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

  List<String> _spritesList = [];

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
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: CarouselSlider.builder(
              options: CarouselOptions(
                height: 100.0,
                // 最初と最後のページ間の遷移
                enableInfiniteScroll: false,
              ),
              itemCount: _spritesList.length,
              // TODO ポケモンのImageUrlリストを作成し、itemIndexごとに表示する
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                print("${itemIndex} : ${pageViewIndex}");
                return Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  // color: Colors.red,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.network(_spritesList[itemIndex]),
                  ),
                );
              }),
        );
      },
    );
  }
}
