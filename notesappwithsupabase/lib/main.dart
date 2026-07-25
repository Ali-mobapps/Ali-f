import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Supabase ko Flutter app se connect karna
  await Supabase.initialize(
    url: 'https://rydmqujtmyyiwbgmxgfv.supabase.co',
    anonKey: 'sb_publishable_SaIzhvgA1IalvSvweKy6LQ_zf31ZVYh',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
      ),
      home: const NotesHomeScreen(),
    );
  }
}

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  // Supabase client ka instance
  final supabase = Supabase.instance.client;

  // --- A. ADD YA EDIT POPUP DIALOG ---
  void _showNoteDialog({int? id, String? currentTitle, String? currentContent}) {
    final titleController = TextEditingController(text: currentTitle);
    final contentController = TextEditingController(text: currentContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Naya Note Banayein' : 'Note Edit Karein'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Details / Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || content.isEmpty) return;

                if (id == null) {
                  // Naya note ADD karo
                  await supabase.from('notes').insert({
                    'title': title,
                    'content': content,
                  });
                } else {
                  // Purana note UPDATE karo
                  await supabase.from('notes').update({
                    'title': title,
                    'content': content,
                  }).eq('id', id);
                }

                if (mounted) Navigator.pop(context);
                setState(() {}); // Screen update karein
              },
              child: Text(id == null ? 'Save' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  // --- B. DELETE FUNCTION ---
  Future<void> _deleteNote(int id) async {
    await supabase.from('notes').delete().eq('id', id);
    setState(() {}); // Screen update karein
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes App 📝'),
        centerTitle: true,
      ),

      // --- C. DATA DISPLAY (FETCH FROM SUPABASE) ---
      body: FutureBuilder(
        future: supabase.from('notes').select().order('id', ascending: false),
        builder: (context, snapshot) {
          // Data load ho raha hai
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error aane par
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notes = snapshot.data as List<dynamic>;

          // Koi data nahi hai
          if (notes.isEmpty) {
            return const Center(
              child: Text('Koi note nahi hai. Niche + button par click karein!'),
            );
          }

          // Data ko Grid View me dikhana
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Ek line me 2 cards
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            note['content'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Edit Icon
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                              onPressed: () => _showNoteDialog(
                                id: note['id'],
                                currentTitle: note['title'],
                                currentContent: note['content'],
                              ),
                            ),
                            // Delete Icon
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: () => _deleteNote(note['id']),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      // Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}