// lib/providers/likes_provider.dart

// On importe l'outil de base de Flutter.
import 'package:flutter/material.dart';

// Cette classe gère l'état des "likes" pour toute l'application.
// "with ChangeNotifier" lui permet d'envoyer des notifications quand les données changent.
class LikesProvider with ChangeNotifier {
  // Une liste privée pour stocker les 'id' des photos qu'on a aimées.
  final List<String> _likedPostIds = [];

  // Une façon "propre" de permettre aux autres widgets de lire la liste, mais pas de la modifier directement.
  List<String> get likedPostIds => _likedPostIds;

  // Une fonction simple pour vérifier si une photo est déjà dans notre liste de favoris.
  bool isPostLiked(String postId) {
    return _likedPostIds.contains(postId);
  }

  // La fonction qui gère le clic sur le bouton "like".
  void toggleLike(String postId) {
    // Si la photo est déjà aimée...
    if (isPostLiked(postId)) {
      // ...on la retire de la liste.
      _likedPostIds.remove(postId);
    } else {
      // Sinon, on l'ajoute à la liste.
      _likedPostIds.add(postId);
    }
    // C'est la ligne la plus importante ! Elle prévient tous les widgets qui écoutent
    // que l'état a changé, pour qu'ils puissent se redessiner (ex: changer le cœur).
    notifyListeners();
  }
}
