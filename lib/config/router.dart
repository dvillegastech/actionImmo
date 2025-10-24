import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/map_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'map',
        pageBuilder: (context, state) => const MaterialPage(
          child: MapScreen(),
        ),
      ),
      // Futures routes pour les calculatrices seront ajoutées ici
    ],
  );
}
