// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

// Mon ThemeProvider gérera si l'application est en mode clair ou sombre.
// C'est comme le système d'éclairage du Normandy, qui peut passer du mode jour au mode nuit.
class ThemeProvider with ChangeNotifier {
  // Par défaut, je commence en mode clair.
  // C'est l'éclairage standard du pont.
  ThemeMode _themeMode = ThemeMode.light;

  // C'est une façon "sûre" de lire le thème actuel.
  ThemeMode get themeMode => _themeMode;

  // Cette fonction me permet de basculer entre le thème clair et le thème sombre.
  // C'est comme activer le mode furtif pour réduire l'éclairage !
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // J'alerte tous les widgets que le thème a changé.
    // Tous les écrans du vaisseau s'ajustent à la nouvelle luminosité !
    notifyListeners();
  }
}