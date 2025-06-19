// lib/services/photo_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_stagram/models/photo.dart';

// Ma classe PhotoService, c'est un peu mon centre de commande pour toutes les opérations liées aux photos.
// C'est ici que je gère comment on va chercher les images.
class PhotoService {
  // J'initialise mon client HTTP Dio. Pour moi, c'est comme le Mako de Mass Effect,
  // mon véhicule tout-terrain pour naviguer sur le web et récupérer des données !
  final Dio _dio = Dio();
  // Je récupère ma clé d'API, cachée dans mes variables d'environnement.
  // C'est super important pour la sécurité, comme les codes d'accès N7 que personne ne doit voir !
  final String? _apiKey = dotenv.env['API_KEY'];
  // Et mon URL de base pour l'API. C'est l'adresse de la Citadelle, là où je vais trouver les photos.
  final String? _apiUrl = dotenv.env['API_URL'];

  // Cette fonction, 'findAll', c'est ma mission principale : aller chercher toutes les photos disponibles.
  // Elle va me retourner une liste d'objets Photo, un peu comme les rapports de mission du Commandant Shepard.
  Future<List<Photo>> findAll() async {
    // Avant de partir en mission, je vérifie toujours que j'ai ma clé d'API et l'URL.
    // Si elles sont manquantes, c'est une alerte rouge ! Impossible de continuer sans ça,
    // comme partir au combat sans armes ni boucliers !
    if (_apiKey == null || _apiUrl == null) {
      throw Exception("Clé d'API ou URL non trouvée dans le fichier .env");
    }

    try {
      // C'est le moment de l'appel à l'API, mon interface avec le reste de la galaxie !
      // --- APPEL API ---
      // J'utilise mon fidèle Dio pour envoyer une requête GET.
      final response = await _dio.get(
        // J'utilise l'endpoint '/photos'. C'est le chemin standard pour accéder aux images.
        // C'est une route bien définie, pas question de se perdre en chemin !
        '$_apiUrl/photos',
        queryParameters: {
          // J'envoie ma 'client_id', qui est ma clé d'API. C'est mon identification pour l'API,
          // un peu comme mon code d'accès N7 pour prouver qui je suis.
          'client_id': _apiKey,
          // Je demande le nombre maximum d'images par page, qui est 30.
          // L'API Unsplash a une limite de 30, c'est comme la limite de munitions que je peux porter !
          'per_page': 30,
        },
      );

      // Une fois la réponse reçue, je vérifie le code de statut.
      // Si c'est 200, c'est un succès ! Mission accomplie, les données sont là !
      if (response.statusCode == 200) {
        // Je récupère la liste des données brutes.
        final List<dynamic> data = response.data;
        // Et je transforme chaque élément brut en un objet Photo utilisable.
        // C'est comme décoder les communications brouillées pour en extraire les informations claires.
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        // Si le code de statut n'est pas 200, il y a eu un problème.
        // Une erreur lors de la récupération des photos, c'est frustrant !
        throw Exception("Erreur lors de la récupération des photos");
      }
    } catch (e) {
      // Si quelque chose se passe mal pendant la connexion (réseau coupé, serveur injoignable...),
      // je l'affiche dans la console pour le débogage. C'est mon journal de bord pour comprendre ce qui cloche.
      print(e);
      // Et je relance une exception, car c'est une erreur critique de connexion à l'API.
      // Un peu comme si mon Normandy ne pouvait plus se connecter à la Citadelle !
      throw Exception("Erreur lors de la connexion à l'API");
    }
  }
}