// lib/providers/display_mode_provider.dart

import 'package:flutter/material.dart';

// Je définis une énumération pour les différents modes d'affichage.
// C'est comme les différentes configurations de vol du Normandy :
// "Grille" pour un aperçu dense, "Colonne" pour plus de détails.
enum DisplayMode { grid, column }

// Mon DisplayModeProvider gérera l'état du mode d'affichage choisi par l'utilisateur.
// Il utilise ChangeNotifier pour notifier les widgets en cas de changement.
// C'est le système de gestion des configurations du pont de navigation.
class DisplayModeProvider with ChangeNotifier {
  // Par défaut, je commence en mode grille, pour un aperçu rapide des images.
  // C'est la configuration par défaut du scanner de Shepard.
  DisplayMode _currentMode = DisplayMode.grid;

  // C'est une façon "sûre" de lire le mode actuel depuis l'extérieur.
  DisplayMode get currentMode => _currentMode;

  // Cette fonction me permet de basculer entre le mode grille et le mode colonne.
  // C'est comme changer l'affichage tactique sur la carte de la galaxie.
  void toggleDisplayMode() {
    _currentMode =
        _currentMode == DisplayMode.grid ? DisplayMode.column : DisplayMode.grid;
    // J'alerte tous les widgets qui écoutent que le mode d'affichage a changé !
    // C'est un message radio à tout l'équipage pour mettre à jour les écrans.
    notifyListeners();
  }
}