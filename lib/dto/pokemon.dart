import 'package:flutter_try_new_feature/dto/move.dart';

class Pokemon {
  // id
  late int id;
  // このポケモンの名前
  late String name;
  // このポケモンを倒したときに得られる基本経験値
  late int baseExperience;
  // このポケモンの身長をデシメートルで表す
  late int height;
  // 各種ごとにデフォルトとして使用されるポケモンを1匹だけ設定する
  // メガシンカやリージョンフォルムのポケモンを検索対象にするとfalse
  late bool isDefault;
  // 並べ替えの順序
  late int order;
  // このポケモンの重さをヘクトグラムで表す
  late int weight;
  // バトル中やオーバーワールドでポケモンが持つパッシブ効果
  // ポケモンは複数の能力を持つことができるが、一度に持つことができる能力は1つだけ
  List abilities = [];
  // このポケモンが取ることができる形態（外見上）の違い
  late List forms;
  // 対象ポケモンが登場するゲームと、そのゲーム内でのインデックス（=恐らく図鑑の表示順序）の一覧
  late List gameIndices;
  // このポケモンが遭遇したときに持っている可能性のあるアイテムのリスト
  late List heldItems;
  // 特定のバージョンに関連するロケーションエリアのリストと遭遇の詳細へのリンク
  late String locationAreaEncounters;
  // ポケモンが覚えることができる技のリスト
  List moves = [];
  // このポケモンが以前の世代で持っていたタイプを示す詳細リスト
  late List pastTypes;
  // ゲーム内でこのポケモンを表現するために使われキャラクタ画像
  late Map sprites;
  // ゲーム内でこのポケモンを表現するために使われる鳴き声のセット
  late Map cries;
  // 1匹のポケモンの基礎（例: ミノマダムのように異なる種を持つ場合）
  late Map species;
  // このポケモンの基本ステータス値のリスト
  List<Map<String, dynamic>> stats = [];
  // このポケモンのタイプを示す詳細リスト
  // late List types;
  List<Map<String, dynamic>> types = [];

  Pokemon(Map<String, dynamic> json) {
    id = json["id"]!;
    name = json["name"]!;
    baseExperience = json["base_experience"]!;
    height = json["height"]!;
    isDefault = json["is_default"]!;
    order = json["order"]!;
    weight = json["weight"]!;
    for (dynamic ability in json["abilities"]!) {
      abilities.add(ability as Map<String, dynamic>);
    }
    forms = json["forms"]!;
    gameIndices = json["game_indices"]!;
    heldItems = json["held_items"]!;
    locationAreaEncounters = json["location_area_encounters"]!;
    for (dynamic move in json["moves"]!) {
      moves.add(move as Map<String, dynamic>);
    }
    pastTypes = json["past_types"]!;
    sprites = json["sprites"]!;
    cries = json["cries"]!;
    species = json["species"]!;
    for (dynamic stat in json["stats"]!) {
      stats.add(stat as Map<String, dynamic>);
    }
    for (dynamic type in json["types"]!) {
      types.add(type as Map<String, dynamic>);
    }
  }

  /// 合計種族値の算出
  int getTotalStats() {
    int resultTotalStats = 0;
    for (Map<String, dynamic> statMap in stats) {
      resultTotalStats += statMap["base_stat"] as int;
    }
    return resultTotalStats;
  }

  /// Heightをメートル(m)変換
  ///
  /// 小数点2桁で四捨五入後、デシメートル(1dm)からメートル(0.1m)に変換する
  double getHeightFromDmToM() {
    return (height * 100).round() / 100 / 10;
  }

  /// Weightをキログラム(kg)変換
  ///
  /// 小数点2桁で四捨五入後、ヘクトグラム(1hg)からキログラム(0.1kg)に変換する
  double getWeightFromHgToKg() {
    return (weight * 100).round() / 100 / 10;
  }

  /// ステータス(種族値)バーの割合計算
  ///
  /// 160pxを100%として、ポケモンの種族値を割合で表示する
  double getStatRate(int stat) {
    double result = (stat / 160 * 100).round() / 100;
    return (result <= 1) ? result : 1;
  }

  /// ポケモンのレベルアップ習得技のレベル取得
  int getLevel(Move move) {
    for (var pokeMove in moves) {
      String urlStr = pokeMove["move"]["url"];
      List<String> tmpUrlList = urlStr.split("/");
      String moveId = tmpUrlList[tmpUrlList.length - 2];

      if (int.parse(moveId) == move.id) {
        List moveDetailList = pokeMove["version_group_details"];
        // TODO Lvupで覚える技とわざマシンで覚える技が同じ場合、Lvが0(わざマシン)が表示されてしまう
        var moveDetail = moveDetailList[moveDetailList.length - 1];
        return moveDetail["level_learned_at"];
      }
    }
    return 0;
  }
}
