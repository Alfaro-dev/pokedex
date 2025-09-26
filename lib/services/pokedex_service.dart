import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_details.dart';

Future<List<Pokemon>> fetchPokemonList() async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> results = data['results'];

    return results.map((json) => Pokemon.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Pokémon');
  }
}

Future<PokemonDetails> fetchPokemonDetails(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return PokemonDetails.fromJson(data);
  } else {
    throw Exception('Failed to load Pokémon details');
  }
}

Future<PokemonDetails> fetchSinglePokemon(String name) async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return PokemonDetails.fromJson(data);
  } else {
    throw Exception('Failed to load Pokémon details for $name');
  }
}