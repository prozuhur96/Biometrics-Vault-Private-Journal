import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/auth_service.dart';
import 'entry_editor_screen.dart';

class JournalHomeScreen extends StatelessWidget {
  const JournalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journalService = JournalService();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Private Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<JournalEntry>>(
        stream: journalService.getEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'No journal entries yet.\nTap + to add your first private entry!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    entry.title.isNotEmpty ? entry.title : 'Untitled',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${entry.createdAt.month}/${entry.createdAt.day}/${entry.createdAt.year}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          await journalService.deleteEntry(entry.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Entry deleted')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EntryEditorScreen(entry: entry),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EntryEditorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}