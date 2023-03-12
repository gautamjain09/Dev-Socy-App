import 'package:devsocy/features/auth/screens/login_screen.dart';
import 'package:devsocy/features/community/screens/add_mods_screen.dart';
import 'package:devsocy/features/community/screens/community_screen.dart';
import 'package:devsocy/features/community/screens/create_community_screen.dart';
import 'package:devsocy/features/community/screens/edit_community_screen.dart';
import 'package:devsocy/features/community/screens/mod_tools_screen.dart';
import 'package:devsocy/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (route) => MaterialPage(
          child: ModToolsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/edit-community/:name': (route) => MaterialPage(
          child: EditCommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (route) => MaterialPage(
          child: AddModsScreen(
            name: route.pathParameters['name']!,
          ),
        ),
  },
);
