import 'package:flutter/material.dart';
import 'package:flutter_try_new_feature/dto/pokemon.dart';

class PokemonDetailDescriptionPage extends StatefulWidget {
  const PokemonDetailDescriptionPage({required this.pokemon, super.key});

  final Pokemon pokemon;

  @override
  State<PokemonDetailDescriptionPage> createState() => _PokemonDetailDescriptionPageState();
}

class _PokemonDetailDescriptionPageState extends State<PokemonDetailDescriptionPage> {
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
      body: Center(
        child: Text(widget.pokemon.name!),
      ),
    );
  }
}
