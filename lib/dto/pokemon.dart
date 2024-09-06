class Pokemon{
  // id
  late int id;
  // このポケモンの名前
  late String name;
  // このポケモンを倒したときに得られる基本経験値
  late int baseExperience;
  // このポケモンの身長をデシメートルで表す
  late int height;
  // 各種ごとにデフォルトとして使用されるポケモンを1匹だけ設定する
  late bool isDefault;
  // 並べ替えの順序
  late int order;
  // このポケモンの重さをヘクトグラムで表す
  late int weight;
  // バトル中やオーバーワールドでポケモンが持つパッシブ効果
  // ポケモンは複数の能力を持つことができるが、一度に持つことができる能力は1つだけ
  late List abilities;
  // このポケモンが取ることができる形態（外見上）の違い
  late List forms;
  //
  late List gameIndices;
  // このポケモンが遭遇したときに持っている可能性のあるアイテムのリスト
  late List heldItems;
  // 特定のバージョンに関連するロケーションエリアのリストと遭遇の詳細へのリンク
  late String locationAreaEncounters;
  // ポケモンが覚えることができる技のリスト
  late List moves;
  // このポケモンが以前の世代で持っていたタイプを示す詳細リスト
  late List pastTypes;
  // ゲーム内でこのポケモンを表現するために使われキャラクタ画像
  late Map sprites;
  // ゲーム内でこのポケモンを表現するために使われる鳴き声のセット
  late Map cries;
  // 1匹のポケモンの基礎（例: ミノマダムのように異なる種を持つ場合）
  late Map species;
  // このポケモンの基本ステータス値のリスト
  late List stats;
  // このポケモンのタイプを示す詳細リスト
  late List types;

  Pokemon(Map<String, dynamic> json){
    id = json["id"]!;
    name = json["name"]!;
    baseExperience = json["base_experience"]!;
    height = json["height"]!;
    isDefault = json["is_default"]!;
    order = json["order"]!;
    weight = json["weight"]!;
    abilities = json["abilities"]!;
    forms = json["forms"]!;
    gameIndices = json["game_indices"]!;
    heldItems = json["held_items"]!;
    locationAreaEncounters = json["location_area_encounters"]!;
    moves = json["moves"]!;
    pastTypes = json["past_types"]!;
    sprites = json["sprites"]!;
    cries = json["cries"]!;
    species = json["species"]!;
    stats = json["stats"]!;
    types = json["types"]!;
  }
}
