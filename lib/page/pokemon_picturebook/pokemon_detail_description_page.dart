import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/dto/pokemon.dart';

class PokemonDetailDescriptionPage extends StatefulWidget {
  const PokemonDetailDescriptionPage({required this.pokemon, super.key});

  final Pokemon pokemon;

  @override
  State<PokemonDetailDescriptionPage> createState() => _PokemonDetailDescriptionPageState();
}

class _PokemonDetailDescriptionPageState extends State<PokemonDetailDescriptionPage> {

  late final Pokemon _pokemon;

  @override
  void initState() {
    super.initState();
    _pokemon = widget.pokemon;
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

  void _showDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Dialog(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(_pokemon.sprites["other"]["showdown"]["front_default"]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
