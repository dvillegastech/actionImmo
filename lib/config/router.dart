import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding_screen.dart';
import '../screens/map_screen.dart';
import '../screens/mes_simulations_screen.dart';
import '../screens/contact_professionals_screen.dart';
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
  static GoRouter createRouter(bool showOnboarding) {
    return GoRouter(
      initialLocation: showOnboarding ? '/onboarding' : '/',
      routes: _routes,
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: _routes,
  );

  static final List<RouteBase> _routes = [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Home - Carte avec calculatrices
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MapScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Mes Simulations
      GoRoute(
        path: '/mes-simulations',
        name: 'mes-simulations',
        pageBuilder: (context, state) => _buildSlideTransition(
          state,
          const MesSimulationsScreen(),
        ),
      ),

      // Contact Professionnels
      GoRoute(
        path: '/contact-professionals',
        name: 'contact-professionals',
        pageBuilder: (context, state) => _buildSlideTransition(
          state,
          const ContactProfessionalsScreen(),
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

  // Helper function for slide transitions
  static CustomTransitionPage _buildSlideTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
