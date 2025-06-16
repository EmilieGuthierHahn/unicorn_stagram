// lib/models/photo.dart

// Définit à quoi ressemble une "Photo" dans notre application.
class Photo {
  // Chaque photo a un identifiant unique (id).
  final String id;
  // Une petite description.
  final String description;
  // L'adresse (URL) de l'image sur internet.
  final String imageUrl;
  // Le nom de l'auteur de la photo.
  final String author;

  // Le "constructeur" : c'est la recette pour créer un objet Photo.
  Photo({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.author,
  });

  // Une méthode spéciale pour créer un objet Photo à partir de données JSON.
  // C'est très utile quand on reçoit des infos d'une API.
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      // On prend l'id depuis le JSON.
      id: json['id'],
      // On prend la description, sinon la description alternative, sinon on met un texte par défaut.
      description: json['description'] ?? json['alt_description'] ?? 'Pas de description',
      // On va chercher l'URL de l'image de petite taille.
      imageUrl: json['urls']['small'],
      // On récupère le nom de l'utilisateur, sinon on met "Auteur inconnu".
      author: json['user']['name'] ?? 'Auteur inconnu',
    );
  }
}
