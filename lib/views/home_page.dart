import 'package:flutter/material.dart';

import '../api/api_services.dart';
import '../models/game.dart';
import 'detail_page.dart';
import 'library_page.dart';
import 'profile_page.dart';

// Halaman utama berisi BottomNavigationBar
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BrowseGames(),
    LibraryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// Tab Home: daftar semua game dari API
class BrowseGames extends StatefulWidget {
  const BrowseGames({super.key});

  @override
  State<BrowseGames> createState() => _BrowseGamesState();
}

class _BrowseGamesState extends State<BrowseGames> {
  List<Game> games = [];
  bool isLoading = true;

  Future<void> fetchGames() async {
    try {
      final gameData = await ApiService.getGames();
      setState(() {
        games = gameData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Browse Games',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(gameId: game.id),
                        ),
                      );
                    },
                    leading: Image.network(
                      game.thumbnail,
                      width: 70,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      game.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.genre,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          game.platform,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
    );
  }
}
