import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Center(
              child: Text(
                'Prompt Vault',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              // TODO: Implement Logout
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging out... (Placeholder)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.code), // Github icon placeholder
            title: const Text('Check me out on Github'),
            onTap: () {
              Navigator.pop(context);
              _launchUrl(
                'https://github.com/petrusjohannesmaas',
              ); // Replace with actual URL if known
            },
          ),
        ],
      ),
    );
  }
}
