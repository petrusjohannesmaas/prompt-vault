import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:prompt_vault/services/firestore_service.dart';
import 'package:prompt_vault/screens/edit_prompt_screen.dart';
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

          return GridView.extent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.8, // Taller cards
            padding: const EdgeInsets.all(8.0),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return _SampleCard(
                docId: doc.id,
                title: data['title'] ?? 'No Title',
                body: data['body'] ?? '',
                onDelete: () => _firestoreService.deletePrompt(doc.id),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPromptScreen(
                        docId: doc.id,
                        initialTitle: data['title'] ?? '',
                        initialBody: data['body'] ?? '',
                      ),
                    ),
                  );
                },
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
    required this.onEdit,
  });

  final String docId;
  final String title;
  final String body;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(),
              Expanded(
                child: Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 6, // Truncate after 6 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: body));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 20),
                    tooltip: 'Copy Body',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
