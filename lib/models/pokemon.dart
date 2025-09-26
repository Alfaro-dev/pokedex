class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String url;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.url ,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {

    final int id = int.parse(json['url'].split('/')[6]);
    final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl: imageUrl,
      url: json['url'],
    );
  }
}