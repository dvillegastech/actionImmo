# Action Immobiliaria 🏠

Application mobile professionnelle pour le marché immobilier français.

## 🎯 Fonctionnalités

### Carte Interactive
- Visualisation des propriétés sur OpenStreetMap
- Filtres Location/Vente
- Affichage des biens disponibles (API à venir)

### Calculatrices Immobilières (À venir)
1. **Frais de Notaire** - Estimation des frais notariaux (ancien vs neuf)
2. **Crédit Immobilier** - Calcul de mensualités avec assurance
3. **Capacité d'Emprunt** - Règle des 33% d'endettement
4. **Plus-Value Immobilière** - Calcul de l'impôt sur la plus-value
5. **Rendement Locatif** - Rentabilité brute et nette
6. **APL/Aides au Logement** - Estimation des aides CAF
7. **Taxe Foncière** - Estimation de l'impôt foncier
8. **PTZ (Prêt à Taux Zéro)** - Éligibilité et montant
9. **Loi Pinel/LMNP** - Avantages fiscaux location
10. **DPE/GES** - Estimation performance énergétique

## 🚀 Technologies

- **Flutter** (version stable)
- **Riverpod** - State Management
- **GoRouter** - Navigation déclarative
- **Flutter Map** - OpenStreetMap
- **Google Fonts** - Typographie Inter

## 🎨 Design

- Interface minimaliste et professionnelle
- Palette: Bleu (#0A2463, #3E92CC) et Noir (#0D1117)
- Material Design 3
- Mode clair/sombre

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
├── config/          # Configuration (Router)
├── models/          # Modèles de données
├── providers/       # Riverpod providers
├── screens/         # Écrans de l'application
├── theme/           # Thème et styles
└── widgets/         # Composants réutilisables
```

## 🇫🇷 Marché Français

Application conçue spécifiquement pour le marché immobilier français:
- Calculs conformes à la législation française
- Terminologie immobilière française
- Normes DPE/GES françaises
- Fiscalité française (PTZ, Pinel, LMNP)
- Aides au logement (APL, CAF)

## 📝 License

Projet privé - Action Immobiliaria © 2025
