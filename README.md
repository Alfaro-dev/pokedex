# Pokédex 📱

Pokédex en **Flutter** que consume la [PokéAPI](https://pokeapi.co/) para listar los 151 Pokémon de la primera generación y ver el detalle de cada uno.

## ✨ Funciones

- Lista de los primeros 151 Pokémon
- Consulta del detalle de cada Pokémon
- Consumo de API REST con `http`

## 🛠️ Stack

- **Flutter / Dart**
- **http** para las peticiones a la PokéAPI
- Organización por capas: `models`, `services` y `views`

## 📁 Estructura

```
lib/
├── models/     # pokemon.dart, pokemon_details.dart
├── services/   # pokedex_service.dart (llamadas a la PokéAPI)
├── views/      # pokedex_screen.dart
└── main.dart
```

## 🚀 Cómo correrlo

```bash
flutter pub get
flutter run
```

---

Desarrollado por [Carlos Alfaro](https://carlosalfaro.dev).
