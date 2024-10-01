class Move {
  late int id;
  late String name;
  // 命中率
  late int? accuracy;
  // 技の効果発動率
  late int? effectChance;
  // 使用回数
  late int pp;
  // 優先度
  late int priority;
  // 威力
  late int? power;
  late Map<String, dynamic>? contestCombos;
  late Map<String, dynamic>? contestType;
  late Map<String, dynamic>? contestEffect;
  late Map<String, dynamic> damageClass;
  late List effectEntries;
  late List effectChanges;
  late List learnedByPokemon;
  // フレーバーテキスト
  late List flavorTextEntries;
  late Map<String, dynamic> generation;
  late List machines;
  late Map<String, dynamic>? meta;
  late List names;
  late List pastValues;
  late List statChanges;
  late Map<String, dynamic>? superContestEffect;
  late Map<String, dynamic> target;
  // タイプ
  late Map<String, dynamic> type;

  Move(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    accuracy = json["accuracy"];
    effectChance = json["effect_chance"];
    pp = json["pp"];
    priority = json["priority"];
    power = json["power"];
    contestCombos = json["contest_combos"];
    contestType = json["contest_type"];
    contestEffect = json["contest_effect"];
    damageClass = json["damage_class"];
    effectEntries = json["effect_entries"];
    effectChanges = json["effect_changes"];
    learnedByPokemon = json["learned_by_pokemon"];
    flavorTextEntries = json["flavor_text_entries"];
    generation = json["generation"];
    machines = json["machines"];
    meta = json["meta"];
    names = json["names"];
    pastValues = json["past_values"];
    statChanges = json["stat_changes"];
    superContestEffect = json["super_contest_effect"];
    target = json["target"];
    type = json["type"];
  }
}
