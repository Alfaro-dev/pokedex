class PokemonDetails {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> abilities;
  final List<dynamic> stats;
  final List<String> types;

  PokemonDetails({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
    required this.types,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    // Mapeo de la lista de habilidades
    final abilitiesList = (json['abilities'] as List)
        .map((abilityJson) => abilityJson['ability']['name'].toString())
        .toList();

    // Mapeo de la lista de estadísticas
    final statsList = (json['stats'] as List)
        .map((statJson) => {
              'name': statJson['stat']['name'].toString(),
              'base_stat': statJson['base_stat'] as int,
            })
        .toList();
        
    // Mapeo de la lista de tipos
    final typesList = (json['types'] as List)
        .map((typeJson) => typeJson['type']['name'].toString())
        .toList();

    return PokemonDetails(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      height: json['height'],
      weight: json['weight'],
      abilities: abilitiesList,
      stats: statsList,
      types: typesList,
    );
  }
}