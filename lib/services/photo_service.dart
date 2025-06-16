// lib/services/photo_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_stagram/models/photo.dart';


class PhotoService {
  final Dio _dio = Dio();
  final String? _apiKey = dotenv.env['API_KEY'];
  final String? _apiUrl = dotenv.env['API_URL'];

  Future<List<Photo>> findAll() async {
    if (_apiKey == null || _apiUrl == null) {
      throw Exception("Clé d'API ou URL non trouvée dans le fichier .env");
    }

    try {
      // --- CORRECTION DE L'APPEL API ---
      final response = await _dio.get(
        // On utilise l'endpoint standard /photos
        '$_apiUrl/photos',
        queryParameters: {
          'client_id': _apiKey,
          // On demande le nombre maximum d'images par page, qui est 30.
          'per_page': 30,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception("Erreur lors de la récupération des photos");
      }
    } catch (e) {
      print(e);
      throw Exception("Erreur lors de la connexion à l'API");
    }
  }
}
