import 'package:devsocy/Responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Responsive(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Community'),
              onTap: () {
                Routemaster.of(context).push('/edit-community/$name');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add moderators'),
              onTap: () {
                Routemaster.of(context).push('/add-mods/$name');
              },
            ),
          ],
        ),
      ),
    );
  }
}
