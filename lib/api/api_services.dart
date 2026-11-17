import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';

class ApiService {
  static const String apiUrl = 'https://www.freetogame.com/api';

  static Future<List<Game>> getGames() async {
    final response = await http.get(Uri.parse('$apiUrl/games'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List games = data;
      return games.map((e) => Game.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<Game> getSingleGame(int gameId) async {
    final response = await http.get(Uri.parse('$apiUrl/game?id=$gameId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Game.fromJson(data);
    } else {
      throw Exception('Failed to load game details');
    }
  }
}
