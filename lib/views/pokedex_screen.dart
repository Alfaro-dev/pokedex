import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../models/pokemon_details.dart';
import '../services/pokedex_service.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Pokemon>> _pokemonListFuture;
  List<Pokemon> _allPokemons = [];
  List<Pokemon> _filteredPokemons = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pokemonListFuture = fetchPokemonList();
    _pokemonListFuture.then((list) {
      setState(() {
        _allPokemons = list;
        _filteredPokemons = list;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        setState(() {
          _filteredPokemons = _allPokemons;
        });
      } else {
        setState(() {
          _filteredPokemons = _allPokemons.where((pokemon) {
            return pokemon.name.toLowerCase().contains(query);
          }).toList();
        });
      }
    });
  }

  void _showPokemonDetailsModal(BuildContext context, String pokemonUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return FutureBuilder<PokemonDetails>(
              future: fetchPokemonDetails(pokemonUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final pokemon = snapshot.data!;
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              pokemon.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Image.network(
                              pokemon.imageUrl,
                              width: 200,
                              height: 200,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Tipos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Wrap(
                            spacing: 8.0,
                            children: pokemon.types.map((type) => Chip(label: Text(type.toUpperCase()))).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text('Habilidades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          ...pokemon.abilities.map((ability) => Text(ability.toUpperCase())),
                          const SizedBox(height: 20),
                          const Text('Estadísticas Base', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          ...pokemon.stats.map((stat) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${stat['name'].toString().replaceAll('-', ' ')}:', style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text(stat['base_stat'].toString()),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No details found.'));
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar Pokémon...',
            hintStyle: const TextStyle(color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<List<Pokemon>>(
          future: _pokemonListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (_allPokemons.isEmpty) {
                return const Center(child: Text('No Pokémon found.'));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: _filteredPokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = _filteredPokemons[index];
                  return InkWell(
                    onTap: () {
                      _showPokemonDetailsModal(context, pokemon.url);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Image.network(pokemon.imageUrl),
                          const SizedBox(height: 8),
                          Text(
                            pokemon.name.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}