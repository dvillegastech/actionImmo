import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/map_screen.dart';
import '../screens/calculators/frais_notaire_screen.dart';
import '../screens/calculators/credit_immobilier_screen.dart';
import '../screens/calculators/capacite_emprunt_screen.dart';
import '../screens/calculators/rendement_locatif_screen.dart';
import '../screens/calculators/plus_value_screen.dart';
import '../screens/calculators/apl_screen.dart';
import '../screens/calculators/taxe_fonciere_screen.dart';
import '../screens/calculators/ptz_screen.dart';
import '../screens/calculators/loi_pinel_screen.dart';
import '../screens/calculators/dpe_ges_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home - Carte avec calculatrices
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => const MaterialPage(
          child: MapScreen(),
        ),
      ),

      // Calculatrices
      GoRoute(
        path: '/frais-notaire',
        name: 'frais-notaire',
        pageBuilder: (context, state) => const MaterialPage(
          child: FraisNotaireScreen(),
        ),
      ),
      GoRoute(
        path: '/credit-immobilier',
        name: 'credit-immobilier',
        pageBuilder: (context, state) => const MaterialPage(
          child: CreditImmobilierScreen(),
        ),
      ),
      GoRoute(
        path: '/capacite-emprunt',
        name: 'capacite-emprunt',
        pageBuilder: (context, state) => const MaterialPage(
          child: CapaciteEmpruntScreen(),
        ),
      ),
      GoRoute(
        path: '/rendement-locatif',
        name: 'rendement-locatif',
        pageBuilder: (context, state) => const MaterialPage(
          child: RendementLocatifScreen(),
        ),
      ),
      GoRoute(
        path: '/plus-value',
        name: 'plus-value',
        pageBuilder: (context, state) => const MaterialPage(
          child: PlusValueScreen(),
        ),
      ),
      GoRoute(
        path: '/apl',
        name: 'apl',
        pageBuilder: (context, state) => const MaterialPage(
          child: AplScreen(),
        ),
      ),
      GoRoute(
        path: '/taxe-fonciere',
        name: 'taxe-fonciere',
        pageBuilder: (context, state) => const MaterialPage(
          child: TaxeFonciereScreen(),
        ),
      ),
      GoRoute(
        path: '/ptz',
        name: 'ptz',
        pageBuilder: (context, state) => const MaterialPage(
          child: PtzScreen(),
        ),
      ),
      GoRoute(
        path: '/loi-pinel',
        name: 'loi-pinel',
        pageBuilder: (context, state) => const MaterialPage(
          child: LoiPinelScreen(),
        ),
      ),
      GoRoute(
        path: '/dpe-ges',
        name: 'dpe-ges',
        pageBuilder: (context, state) => const MaterialPage(
          child: DpeGesScreen(),
        ),
      ),
    ],
  );
}
