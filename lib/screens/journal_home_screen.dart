import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/auth_service.dart';
import 'entry_editor_screen.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({super.key});

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  final JournalService _journalService = JournalService();
  final AuthService _authService = AuthService();
  
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Private Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search journal entries...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          
          // Entries Stream Builder
          Expanded(
            child: StreamBuilder<List<JournalEntry>>(
              stream: _journalService.getEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allEntries = snapshot.data ?? [];

                // Filter entries locally based on decrypted search query
                final filteredEntries = allEntries.where((entry) {
                  final titleMatch = entry.title.toLowerCase().contains(_searchQuery);
                  final contentMatch = entry.content.toLowerCase().contains(_searchQuery);
                  return titleMatch || contentMatch;
                }).toList();

                if (filteredEntries.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No journal entries yet.\nTap + to add your first private entry!'
                          : 'No matching entries found.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) {
                    final entry = filteredEntries[index];
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
                                await _journalService.deleteEntry(entry.id);
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
          ),
        ],
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