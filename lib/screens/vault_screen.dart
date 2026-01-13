import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:prompt_vault/services/firestore_service.dart';
import 'package:prompt_vault/screens/wizard_screen.dart';
import 'package:prompt_vault/widgets/app_drawer.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text('Prompt Vault'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WizardScreen(
                    onSaveSuccess: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getPromptsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("😶‍🌫️", style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text(
                    "No prompts stored yet!",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8.0),
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Center(
                child: Card.filled(
                  child: _SampleCard(
                    docId: doc.id,
                    title: data['title'] ?? 'No Title',
                    body: data['body'] ?? '',
                    onDelete: () => _firestoreService.deletePrompt(doc.id),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({
    required this.docId,
    required this.title,
    required this.body,
    required this.onDelete,
  });

  final String docId;
  final String title;
  final String body;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Delete',
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: body));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  tooltip: 'Copy Body',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
