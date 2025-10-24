import 'package:flutter/material.dart';

enum CalculatorType {
  fraisNotaire,
  creditImmobilier,
  capaciteEmprunt,
  plusValue,
  rendementLocatif,
  apl,
  taxeFonciere,
  ptz,
  loiPinel,
  dpeGes,
}

class CalculatorInfo {
  final CalculatorType type;
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const CalculatorInfo({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });

  static const List<CalculatorInfo> allCalculators = [
    CalculatorInfo(
      type: CalculatorType.fraisNotaire,
      title: 'Frais de Notaire',
      description: 'Estimation des frais notariaux (ancien 7-8%, neuf 2-3%)',
      icon: Icons.gavel,
      route: '/frais-notaire',
    ),
    CalculatorInfo(
      type: CalculatorType.creditImmobilier,
      title: 'Crédit Immobilier',
      description: 'Calcul de mensualités avec taux et assurance',
      icon: Icons.account_balance,
      route: '/credit-immobilier',
    ),
    CalculatorInfo(
      type: CalculatorType.capaciteEmprunt,
      title: 'Capacité d\'Emprunt',
      description: 'Déterminez votre budget (règle des 33%)',
      icon: Icons.trending_up,
      route: '/capacite-emprunt',
    ),
    CalculatorInfo(
      type: CalculatorType.rendementLocatif,
      title: 'Rendement Locatif',
      description: 'Rentabilité brute et nette de votre investissement',
      icon: Icons.percent,
      route: '/rendement-locatif',
    ),
    CalculatorInfo(
      type: CalculatorType.plusValue,
      title: 'Plus-Value Immobilière',
      description: 'Calcul de l\'impôt sur la plus-value',
      icon: Icons.show_chart,
      route: '/plus-value',
    ),
    CalculatorInfo(
      type: CalculatorType.apl,
      title: 'APL / Aides au Logement',
      description: 'Estimation des aides CAF',
      icon: Icons.home_work,
      route: '/apl',
    ),
    CalculatorInfo(
      type: CalculatorType.taxeFonciere,
      title: 'Taxe Foncière',
      description: 'Estimation de l\'impôt foncier',
      icon: Icons.receipt_long,
      route: '/taxe-fonciere',
    ),
    CalculatorInfo(
      type: CalculatorType.ptz,
      title: 'PTZ (Prêt à Taux Zéro)',
      description: 'Éligibilité et montant du PTZ',
      icon: Icons.savings,
      route: '/ptz',
    ),
    CalculatorInfo(
      type: CalculatorType.loiPinel,
      title: 'Loi Pinel / LMNP',
      description: 'Avantages fiscaux location meublée',
      icon: Icons.business_center,
      route: '/loi-pinel',
    ),
    CalculatorInfo(
      type: CalculatorType.dpeGes,
      title: 'DPE / GES',
      description: 'Estimation performance énergétique',
      icon: Icons.energy_savings_leaf,
      route: '/dpe-ges',
    ),
  ];
}
