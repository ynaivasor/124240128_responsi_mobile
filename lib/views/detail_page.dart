import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/api_services.dart';
import '../models/game.dart';

class DetailPage extends StatefulWidget {
  final int gameId;
  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Game? game;
  bool isLoading = true;
  bool isOwned = false;

  Future<void> fetchSingleGame() async {
    try {
      final gameData = await ApiService.getSingleGame(widget.gameId);
      final box = Hive.box<Game>('library');
      setState(() {
        game = gameData;
        isOwned = box.values.any((g) => g.id == gameData.id);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _getGame() {
    if (isOwned || game == null) return;
    Hive.box<Game>('library').add(game!);
    setState(() {
      isOwned = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game ditambahkan ke library')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSingleGame();
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : game == null
          ? const Center(child: Text('Gagal memuat data game'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    game!.thumbnail,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [_chip(game!.genre), _chip(game!.platform)],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          game!.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _info('Release Date', game!.releaseDate),
                            _info('Publisher', game!.publisher),
                            _info('Developer', game!.developer),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isOwned
                                  ? Colors.grey[800]
                                  : Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: isOwned ? null : _getGame,
                            icon: Icon(isOwned ? Icons.check : Icons.add),
                            label: Text(isOwned ? 'In Library' : 'Get'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Screenshots',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: game!.screenshots.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    game!.screenshots[index],
                                    width: 160,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game!.description,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
