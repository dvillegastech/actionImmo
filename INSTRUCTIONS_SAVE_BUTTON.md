# Instrucciones: Agregar Botón Guardar a Todas las Calculadoras

## ✅ Ya Completado
- ✅ Frais de Notaire

## 📝 Pendiente de Agregar
- ⏳ Crédit Immobilier
- ⏳ Capacité d'Emprunt
- ⏳ Rendement Locatif
- ⏳ Plus-Value
- ⏳ APL
- ⏳ Taxe Foncière
- ⏳ PTZ
- ⏳ Loi Pinel
- ⏳ DPE/GES

---

## 🚀 Pasos para Agregar (Copiar-Pegar)

### 1. Agregar Import
Al inicio del archivo `.dart`, agregar:

```dart
import '../../widgets/save_simulation_button.dart';
```

### 2. Agregar el Botón
Dentro del `if (resultados != null)`, **AL FINAL**, antes del cierre de corchetes, agregar:

```dart
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'NOMBRE_DE_LA_CALCULADORA',
  enabled: CONDICION_DE_RESULTADOS != null,
  inputs: {
    'Campo1': 'valor1',
    'Campo2': 'valor2',
  },
  results: {
    'Resultado1': 'valor1',
    'Resultado2': 'valor2',
  },
),
```

---

## 📋 Ejemplos Específicos

### Crédit Immobilier
**Archivo**: `lib/screens/calculators/credit_immobilier_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'Crédit Immobilier',
  enabled: _mensualite != null,
  inputs: {
    'Montant emprunté': '${_montantController.text} €',
    'Durée': '${_dureeController.text} ans',
    'Taux': '${_tauxController.text} %',
    'Assurance': '${_assuranceController.text} %',
  },
  results: {
    'Mensualité': '${_mensualite?.toStringAsFixed(2) ?? '0'} €',
    'Coût total': '${_coutTotal?.toStringAsFixed(0) ?? '0'} €',
    'Intérêts': '${_interetsTotal?.toStringAsFixed(0) ?? '0'} €',
  },
),
```

### Capacité d'Emprunt
**Archivo**: `lib/screens/calculators/capacite_emprunt_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'Capacité d\'Emprunt',
  enabled: _capaciteEmprunt != null,
  inputs: {
    'Revenus mensuels': '${_revenuController.text} €',
    'Charges': '${_chargesController.text} €',
    'Apport': '${_apportController.text} €',
    'Taux': '${_tauxController.text} %',
    'Durée': '${_dureeController.text} ans',
  },
  results: {
    'Capacité d\'emprunt': '${_capaciteEmprunt?.toStringAsFixed(0) ?? '0'} €',
    'Budget total': '${_budgetTotal?.toStringAsFixed(0) ?? '0'} €',
    'Mensualité max': '${_mensualiteMax?.toStringAsFixed(0) ?? '0'} €',
  },
),
```

### PTZ
**Archivo**: `lib/screens/calculators/ptz_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados (dentro del if (_eligible!)), agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'PTZ',
  enabled: _eligible == true,
  inputs: {
    'Zone': _zone,
    'Personnes': '$_personnes',
    'Revenus': '${_revenuController.text} €',
    'Prix': '${_prixController.text} €',
  },
  results: {
    'Montant PTZ': '${_montantPTZ?.toStringAsFixed(0) ?? '0'} €',
    'Quotité': '${(_quotite! * 100).toInt()}%',
    'Éligible': 'Oui',
  },
),
```

### Taxe Foncière
**Archivo**: `lib/screens/calculators/taxe_fonciere_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'Taxe Foncière',
  enabled: _taxeFonciere != null,
  inputs: {
    'Commune': _commune,
    'Type de bien': _typeBien,
    if (_useVlc) 'VLC': '${_vlcController.text} €',
    if (!_useVlc) 'Surface': '${_surfaceController.text} m²',
  },
  results: {
    'Taxe foncière': '${_taxeFonciere?.toStringAsFixed(0) ?? '0'} €',
    'Taux communal': '${_tauxCommune?.toStringAsFixed(1) ?? '0'}%',
  },
),
```

### APL
**Archivo**: `lib/screens/calculators/apl_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados (dentro del if (_eligible! && _montantAPL! > 0)), agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'APL',
  enabled: _eligible == true && _montantAPL != null && _montantAPL! > 0,
  inputs: {
    'Situation': _situation,
    'Personnes': '$_personnes',
    'Zone': _zone,
    'Revenus': '${_revenuController.text} €',
    'Loyer': '${_loyerController.text} €',
  },
  results: {
    'APL estimée': '${_montantAPL?.toStringAsFixed(0) ?? '0'} €/mois',
  },
),
```

### DPE/GES
**Archivo**: `lib/screens/calculators/dpe_ges_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'DPE/GES',
  enabled: _classeFinale != null,
  inputs: {
    'Surface': '${_surfaceController.text} m²',
    'Consommation': '${_consoController.text} kWh/m²/an',
    'Émissions': '${_emissionsController.text} kg CO₂/m²/an',
  },
  results: {
    'Classe DPE/GES': _classeFinale ?? '',
    'Consommation': _classeConso ?? '',
    'Émissions': _classeEmissions ?? '',
  },
),
```

### Loi Pinel
**Archivo**: `lib/screens/calculators/loi_pinel_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'Loi Pinel',
  enabled: _reductionImpot != null,
  inputs: {
    'Prix d\'acquisition': '${_prixController.text} €',
    'Durée': '$_duree ans',
  },
  results: {
    'Réduction totale': '${_reductionImpot?.toStringAsFixed(0) ?? '0'} €',
    'Économie annuelle': '${_economieAnnuelle?.toStringAsFixed(0) ?? '0'} €',
  },
),
```

### Rendement Locatif
**Archivo**: `lib/screens/calculators/rendement_locatif_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'Rendement Locatif',
  enabled: _rendementBrut != null,
  inputs: {
    'Prix d\'achat': '${_prixAchatController.text} €',
    'Frais d\'achat': '${_fraisAchatController.text} €',
    'Loyer mensuel': '${_loyerController.text} €',
    'Charges': '${_chargesController.text} €',
    'Taxe foncière': '${_taxeFonciereController.text} €',
  },
  results: {
    'Rendement brut': '${_rendementBrut?.toStringAsFixed(2) ?? '0'}%',
    'Rendement net': '${_rendementNet?.toStringAsFixed(2) ?? '0'}%',
    'Cash-flow annuel': '${_cashflowAnnuel?.toStringAsFixed(0) ?? '0'} €',
  },
),
```

### Plus-Value
**Archivo**: `lib/screens/calculators/plus_value_screen.dart`

```dart
// 1. Agregar import
import '../../widgets/save_simulation_button.dart';

// 2. Al final de los resultados, agregar:
const SizedBox(height: 24),

SaveSimulationButton(
  calculatorName: 'Plus-Value Immobilière',
  enabled: _impotPlusValue != null,
  inputs: {
    'Prix d\'achat': '${_prixAchatController.text} €',
    'Prix de vente': '${_prixVenteController.text} €',
    'Années de détention': '${_anneesController.text} ans',
  },
  results: {
    'Plus-value brute': '${_plusValueBrute?.toStringAsFixed(0) ?? '0'} €',
    'Plus-value imposable': '${_plusValueImposable?.toStringAsFixed(0) ?? '0'} €',
    'Impôt': '${_impotPlusValue?.toStringAsFixed(0) ?? '0'} €',
  },
),
```

---

## 🎯 Checklist

Después de agregar a cada calculadora:

1. ✅ Import agregado
2. ✅ SaveSimulationButton colocado al final de resultados
3. ✅ calculatorName correcto
4. ✅ enabled tiene la condición correcta
5. ✅ inputs contienen los campos de entrada
6. ✅ results contienen los resultados calculados
7. ✅ Commit y push

---

## 🚀 Comando Git para Commit

```bash
git add lib/screens/calculators/[nombre]_screen.dart
git commit -m "Add save functionality to [Nombre] calculator"
git push
```

---

## ✨ Resultado Final

Cuando el usuario calcule algo en cualquier calculadora:
1. Verá el botón "Sauvegarder" 💾
2. Al tocarlo, se guardará en Hive
3. Verá un SnackBar verde ✅
4. Podrá ver el historial en "Mes Simulations" 📊
