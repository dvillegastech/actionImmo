# Action Immobiliaria 🏠

Application mobile professionnelle pour le marché immobilier français avec calculatrices complètes.

## ✨ Fonctionnalités

### 🗺️ Carte Interactive (Écran Principal)
- Visualisation des propriétés sur OpenStreetMap
- Filtres Location/Vente en haut
- **3 calculatrices principales** en bas :
  - Frais de Notaire
  - Crédit Immobilier
  - Capacité d'Emprunt
- **Bouton "Plus"** pour accéder aux 7 autres calculatrices

### 🧮 Calculatrices Immobilières (10 outils)

#### Calculatrices Financières
1. **Frais de Notaire** ✅
   - Ancien (7-8%) vs Neuf (2-3%)
   - Calcul automatique du total à payer

2. **Crédit Immobilier** ✅
   - Mensualités avec assurance
   - Coût total du crédit
   - Taux actuels du marché français

3. **Capacité d'Emprunt** ✅
   - Règle des 33% d'endettement
   - Budget total avec apport
   - Mensualité maximale

4. **Plus-Value Immobilière** ✅
   - Calcul de l'impôt sur la plus-value
   - Abattements pour durée de détention
   - Exonération après 30 ans

5. **Rendement Locatif** ✅
   - Rentabilité brute et nette
   - Cashflow annuel/mensuel
   - Indicateurs de performance

#### Aides & Fiscalité
6. **APL / Aides au Logement** ✅
   - APL, ALF, ALS
   - Conditions d'éligibilité
   - Lien vers simulateur CAF

7. **Taxe Foncière** ✅
   - Informations de calcul
   - Montants moyens
   - Exonérations possibles

8. **PTZ (Prêt à Taux Zéro)** ✅
   - Conditions 2024
   - Plafonds par zone
   - Montants éligibles

9. **Loi Pinel / LMNP** ✅
   - Réductions d'impôt Pinel
   - Avantages LMNP
   - Comparatif des dispositifs

10. **DPE / GES** ✅
    - Classes énergétiques A-G
    - Réglementation passoires thermiques
    - Obligations légales

## 🎨 Design

- Interface minimaliste et professionnelle
- Material Design 3
- Palette: Bleu (#0A2463, #3E92CC) et Noir (#0D1117)
- Typographie: Google Fonts Inter
- Mode clair/sombre

## 🚀 Technologies

- **Flutter** (SDK >=3.5.0)
- **Riverpod 2.6.1** - State Management
- **GoRouter 14.6.2** - Navigation
- **Flutter Map 7.0.2** - OpenStreetMap
- **Google Fonts 6.2.1** - Typographie
- **Intl 0.19.0** - Formatage

## 📦 Installation

```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Build pour production
flutter build apk       # Android
flutter build ios       # iOS
flutter build web       # Web
```

## 📱 Structure du Projet

```
lib/
├── config/
│   └── router.dart              # GoRouter configuration
├── models/
│   ├── calculator_type.dart     # Types de calculatrices
│   └── property_type.dart       # Location/Vente
├── providers/
│   └── property_type_provider.dart  # Riverpod state
├── screens/
│   ├── home_screen.dart         # Écran principal
│   ├── map_screen.dart          # Carte OpenStreetMap
│   └── calculators/             # 10 calculatrices
│       ├── frais_notaire_screen.dart
│       ├── credit_immobilier_screen.dart
│       ├── capacite_emprunt_screen.dart
│       ├── rendement_locatif_screen.dart
│       ├── plus_value_screen.dart
│       ├── apl_screen.dart
│       ├── taxe_fonciere_screen.dart
│       ├── ptz_screen.dart
│       ├── loi_pinel_screen.dart
│       └── dpe_ges_screen.dart
├── theme/
│   └── app_theme.dart           # Thème complet
└── widgets/
    ├── calculator_scaffold.dart # Layout calculatrices
    ├── input_field.dart         # Champs de saisie
    └── result_card.dart         # Cartes de résultats
```

## 🇫🇷 Spécificités Marché Français

- Calculs conformes à la législation française 2024
- Terminologie immobilière française
- Normes DPE/GES françaises
- Fiscalité française (PTZ, Pinel, LMNP)
- Aides au logement (APL, CAF)
- Taux d'endettement 33%
- Frais de notaire selon ancien/neuf

## 📝 License

Projet privé - Action Immobiliaria © 2025
