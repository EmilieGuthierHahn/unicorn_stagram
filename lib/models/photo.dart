// lib/models/photo.dart

// Cette classe 'Photo' est super importante : elle définit la structure de ce qu'est une "Photo" dans mon application.
// C'est un peu comme si je définissais les spécifications techniques d'un vaisseau spatial dans Mass Effect :
// quels sont ses composants essentiels, ses caractéristiques.
class Photo {
  // Chaque photo a un **identifiant unique (id)**. C'est crucial pour la traçabilité,
  // comme le numéro d'immatriculation d'un vaisseau ou l'identifiant d'un soldat N7 !
  final String id;
  // J'ajoute une **petite description** pour chaque photo. C'est utile pour donner du contexte,
  // un peu comme les entrées du Codex qui donnent des détails sur les planètes ou les espèces.
  final String description;
  // L'**adresse (URL) de l'image** sur internet. Sans ça, pas de visuel !
  // C'est comme les coordonnées d'un système stellaire pour y accéder.
  final String imageUrl;
  // Et bien sûr, le **nom de l'auteur de la photo**. Il faut toujours créditer les créateurs,
  // comme les ingénieurs qui ont conçu les technologies du Normandy.
  final String author;

  // Voici le **"constructeur"** de ma classe 'Photo'. C'est la "recette" pour créer un nouvel objet 'Photo'.
  // Quand je veux instancier une nouvelle photo, je dois lui fournir toutes ces informations.
  // Les 'required' signifient que ces données sont absolument nécessaires, on ne peut pas créer une photo sans elles,
  // comme on ne peut pas construire un vaisseau sans moteur ou sans bouclier !
  Photo({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.author,
  });

  // Cette **méthode spéciale 'fromJson'** est une "factory". Elle est là pour un but très précis :
  // créer un objet 'Photo' à partir de données reçues au format JSON.
  // C'est super utile quand je communique avec une API (comme Unsplash), car elle me renvoie des données brutes
  // que je dois transformer en quelque chose d'utilisable dans mon application.
  // C'est comme le décodeur universel de la galaxie qui transforme les signaux extraterrestres en informations exploitables !
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      // Je vais chercher l'**id** directement depuis le JSON que l'API m'a envoyé.
      // C'est la première chose que je récupère, l'identifiant principal.
      id: json['id'],
      // Pour la **description**, je suis un peu plus malin.
      // J'essaie de prendre 'description' en premier. S'il n'y a rien, je tente 'alt_description' (description alternative).
      // Et si les deux sont vides, je mets un texte par défaut : 'Pas de description'.
      // C'est ma stratégie de repli, comme le plan B de Shepard quand le plan A échoue !
      description: json['description'] ?? json['alt_description'] ?? 'Pas de description',
      // Pour l'**imageUrl**, je vais chercher l'URL de l'image de petite taille ('small').
      // Souvent, les API offrent différentes tailles d'images, et pour une application mobile, le format 'small' est parfait
      // pour économiser de la bande passante, un peu comme optimiser les ressources pour une mission longue durée.
      imageUrl: json['urls']['small'],
      // Enfin, je récupère le **nom de l'auteur** depuis le champ 'user' puis 'name' dans le JSON.
      // Si pour une raison quelconque le nom de l'utilisateur n'est pas disponible, je mets 'Auteur inconnu'.
      // Mieux vaut avoir un "Inconnu" que rien du tout, pour éviter les erreurs !
      author: json['user']['name'] ?? 'Auteur inconnu',
    );
  }
}