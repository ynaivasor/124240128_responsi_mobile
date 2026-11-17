import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/game.dart';
import 'detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library Anda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Game>('library').listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(child: Text('Library masih kosong'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final game = box.getAt(index);
              if (game == null) return const SizedBox.shrink();
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
                      Text(game.platform, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      box.deleteAt(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
