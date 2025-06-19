// lib/providers/likes_provider.dart

// On importe l'outil de base de Flutter.
import 'package:flutter/material.dart';

// Cette classe 'LikesProvider', c'est un peu mon centre de contrôle pour les "likes" dans l'application.
// Elle gère l'état global des photos que j'ai aimées, un peu comme mon journal de bord des succès dans Mass Effect.
// Le "with ChangeNotifier" est crucial ici : ça lui permet d'envoyer des notifications à tous les écrans qui "écoutent".
// C'est comme la radio du Normandy qui informe l'équipage des nouvelles directives de Shepard !
class LikesProvider with ChangeNotifier {
  // Voici ma liste privée, '_likedPostIds'. C'est là que je stocke les identifiants (les 'id') de toutes les photos
  // que j'ai "likées". Je la garde privée pour être sûr que personne ne vienne la modifier directement sans passer
  // par les procédures établies, un peu comme les dossiers confidentiels de l'Alliance !
  final List<String> _likedPostIds = [];

  // Cette propriété 'likedPostIds' est une façon "propre" et sécurisée de permettre aux autres parties de mon code
  // de lire cette liste. Elles peuvent voir ce que j'ai aimé, mais elles ne peuvent pas ajouter ou retirer des éléments
  // directement. C'est comme donner l'accès en lecture seule aux rapports de mission !
  List<String> get likedPostIds => _likedPostIds;

  // Cette petite fonction 'isPostLiked' est super pratique. Elle me permet de vérifier rapidement
  // si une photo spécifique est déjà dans ma liste de favoris.
  // C'est comme vérifier dans mon codex si j'ai déjà scanné une nouvelle espèce ou découvert un site important !
  bool isPostLiked(String postId) {
    return _likedPostIds.contains(postId);
  }

  // La fonction clé : 'toggleLike'. C'est elle qui gère ce qui se passe quand on clique sur le bouton "like".
  // C'est mon action "J'aime/Je n'aime plus" !
  void toggleLike(String postId) {
    // Je commence par vérifier si la photo est déjà dans mes favoris grâce à 'isPostLiked'.
    // Si c'est le cas, ça veut dire que l'utilisateur veut "un-liker" la photo.
    if (isPostLiked(postId)) {
      // Donc, je la retire de ma liste. Moins de données à gérer, c'est toujours bon !
      // Un peu comme si je décidais de ne plus traquer une cible secondaire.
      _likedPostIds.remove(postId);
    } else {
      // Sinon, si la photo n'est pas encore aimée, c'est que l'utilisateur veut l'ajouter.
      // C'est une nouvelle photo favorite !
      // Alors, je l'ajoute à ma liste. Ça rejoint mes collections précieuses, comme les améliorations du Normandy !
      _likedPostIds.add(postId);
    }
    // Et voici la ligne la plus importante, le point culminant de l'opération !
    // 'notifyListeners()' est ce qui déclenche une mise à jour pour tous les widgets qui utilisent ce 'LikesProvider'.
    // Cela signifie que si un bouton "like" ou un compteur de likes est affiché à l'écran, il va se redessiner
    // pour montrer le nouvel état (par exemple, le cœur qui change de couleur).
    // C'est comme quand Shepard donne un ordre sur le Normandy : tout l'équipage réagit et agit en conséquence !
    notifyListeners();
  }
}