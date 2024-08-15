import 'package:flutter/material.dart';

class PokemonDetailDescriptionPage extends StatefulWidget {
  const PokemonDetailDescriptionPage({super.key});

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
        child: Text("仮ページ"),
      ),
    );
  }
}
