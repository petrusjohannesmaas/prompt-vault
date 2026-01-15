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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Professional':
        return Colors.blue.shade100;
      case 'Questions':
        return Colors.orange.shade100;
      case 'Step by step':
        return Colors.green.shade100;
      case 'Standard':
      default:
        return Colors.purple.shade100;
    }
  }

  Color _getTypeTextColor(String type) {
    switch (type) {
      case 'Professional':
        return Colors.blue.shade900;
      case 'Questions':
        return Colors.orange.shade900;
      case 'Step by step':
        return Colors.green.shade900;
      case 'Standard':
      default:
        return Colors.purple.shade900;
    }
  }

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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search prompts...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : const Text('Prompt Vault'),
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

          var docs = snapshot.data?.docs ?? [];

          // Filter by search query
          if (_searchQuery.isNotEmpty) {
            docs = docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final title = (data['title'] ?? '').toString().toLowerCase();
              final body = (data['body'] ?? '').toString().toLowerCase();
              return title.contains(_searchQuery) ||
                  body.contains(_searchQuery);
            }).toList();
          }

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("😶‍🌫️", style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? "No prompts stored yet!"
                        : "No matching prompts found.",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return GridView.extent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.9, // Adjusted aspect ratio
            padding: const EdgeInsets.all(16.0),
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final type = data['type'] ?? 'Standard';

              return _SampleCard(
                docId: doc.id,
                title: data['title'] ?? 'No Title',
                body: data['body'] ?? '',
                type: type,
                tagColor: _getTypeColor(type),
                tagTextColor: _getTypeTextColor(type),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchQuery = "";
              _searchController.clear();
            }
          });
        },
        child: Icon(_isSearching ? Icons.close : Icons.search),
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({
    required this.docId,
    required this.title,
    required this.body,
    required this.type,
    required this.tagColor,
    required this.tagTextColor,
    required this.onDelete,
    required this.onEdit,
  });

  final String docId;
  final String title;
  final String body;
  final String type;
  final Color tagColor;
  final Color tagTextColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Professional':
        return Icons.business_center;
      case 'Questions':
        return Icons.school;
      case 'Step by step':
        return Icons.list;
      case 'Standard':
      default:
        return Icons.bolt;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Truncate body to 42 chars
    final displayBody = body.length > 42 ? "${body.substring(0, 42)}..." : body;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onEdit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Truncated Body
            Text(
              displayBody,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const Spacer(),
            // Tag and Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: tagTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    _getTypeIcon(type),
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Actions Row (Divider + Icons)
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Empty container to push icons to the right if desired,
                // or we can put Copy on left and Actions on right.
                // Reverting to previous layout style but with Copy restored.
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: body));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                  tooltip: 'Copy',
                ),

                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey,
                      ),
                      tooltip: 'Edit',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
