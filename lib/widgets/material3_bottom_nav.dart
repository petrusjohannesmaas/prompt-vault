import 'package:flutter/material.dart';
// import 'package:prompt_vault/screens/wizard_screen.dart';
import '../screens/vault_screen.dart';
// import '../screens/wizard_screen.dart';
import '../screens/summarizer_screen.dart';
import '../screens/settings_drawer.dart';

class Material3BottomNav extends StatefulWidget {
  const Material3BottomNav({super.key});

  @override
  State<Material3BottomNav> createState() => _Material3BottomNavState();
}

class _Material3BottomNavState extends State<Material3BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    VaultScreen(),
    SummarizerScreen(),
    // WizardScreen(),
    SettingsDrawer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(_navBarItems[_selectedIndex].label)),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
      ),
    );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.snippet_folder_outlined),
    selectedIcon: Icon(Icons.snippet_folder_rounded),
    label: 'Vault',
  ),
  NavigationDestination(
    icon: Icon(Icons.post_add_outlined),
    selectedIcon: Icon(Icons.post_add_rounded),
    label: 'Wizard',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings_rounded),
    label: 'Settings',
  ),
];
