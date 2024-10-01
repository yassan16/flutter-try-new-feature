import 'dart:convert';

import 'package:flutter_try_new_feature/dto/move.dart';
import 'package:flutter_try_new_feature/dto/pokemon_species.dart';
import 'package:http/http.dart' as http;

/// pokeAPIを呼び出すためのクラス
class CallPokeApi {
  /// ポケモンの取得
  ///
  /// https://pokeapi.co/docs/v2#pokemon
  Future<Map<String, dynamic>> getPokemon({required String id}) async {
    var url = Uri.https("pokeapi.co", "/api/v2/pokemon/${id}/");
    var response = await http.get(url);
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return responseJson;
  }

  /// ポケモンspeciesの取得
  ///
  /// https://pokeapi.co/docs/v2#pokemon-species
  Future<PokemonSpecies> getPokemonSpecies({required String id}) async {
    var url = Uri.https("pokeapi.co", "/api/v2/pokemon-species/${id}/");
    var response = await http.get(url);
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonSpecies(responseJson);
  }

  /// 全世代の世代取得APIのURL取得
  ///
  /// https://pokeapi.co/docs/v2#resource-listspagination-section
  Future<Map> getALLGenerationApiUrl() async {
    // 全世代のAPIを呼ぶために、APIのURLを取得
    var url = Uri.https("pokeapi.co", "/api/v2/generation/");
    var response = await http.get(url);
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return responseJson;
  }

  /// 世代データ取得API呼び出し
  ///
  /// https://pokeapi.co/docs/v2#games-section
  Future<Map> getPokemonFromGeneration(String geneInt) async {
    // 全世代のAPIを呼ぶために、APIのURLを取得
    var url = Uri.https("pokeapi.co", "/api/v2/generation/${geneInt}");
    var response = await http.get(url);
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return responseJson;
  }

  /// 技の取得
  ///
  /// https://pokeapi.co/api/v2/move/{id or name}/
  Future<Move> getMove({required String id}) async {
    var url = Uri.https("pokeapi.co", "/api/v2/move/$id/");
    var response = await http.get(url);
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return Move(responseJson);
  }
}
