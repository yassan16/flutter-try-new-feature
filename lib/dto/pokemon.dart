class Pokemon{
  int? id;
  String? name;
  int? baseExperience;
  int? height;
  bool? isDefault;
  int? order;
  int? weight;
  List? abilities;
  List? forms;
  List? gameIndices;
  List? heldItems;
  String? locationAreaEncounters;
  List? moves;
  List? pastTypes;
  Map? sprites;
  Map? cries	;
  Map? species;
  List? stats;
  List? types;

  Pokemon(Map<String, dynamic> json){
    this.id = json["id"];
    this.name = json["name"];
    this.baseExperience = json["base_experience"];
    this.height = json["height"];
    this.isDefault = json["is_default"];
    this.order = json["order"];
    this.weight = json["weight"];
    this.abilities = json["abilities"];
    this.forms = json["forms"];
    this.gameIndices = json["game_indices"];
    this.heldItems = json["held_items"];
    this.locationAreaEncounters = json["location_area_encounters"];
    this.moves = json["moves"];
    this.pastTypes = json["past_types"];
    this.sprites = json["sprites"];
    this.cries = json["cries"];
    this.species = json["species"];
    this.stats = json["stats"];

    this.types = json["types"];

  }
}
