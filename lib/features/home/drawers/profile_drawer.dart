import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.watch(authControllerProvider.notifier).logOut();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 75,
            ),
            Text(
              "u/${user.name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                Routemaster.of(context).push('u/${user.uid}');
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () {
                logOut(ref);
              },
            ),
            // Theme Toggler
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
            )
          ],
        ),
      ),
    );
  }
}
