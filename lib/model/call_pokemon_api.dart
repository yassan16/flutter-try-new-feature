import 'dart:convert';

import 'package:http/http.dart' as http;

class CallPokeApi {

  /// ポケモンの取得
  Future<String> getPokemon({required String id}) async {
    var url = Uri.https("pokeapi.co", "/api/v2/pokemon/${id}/");
    var response = await http.get(url);

    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    var resultApiText = responseJson["sprites"]["front_default"];

    return resultApiText;
  }
}
