// lib/widgets/details_modal.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:unicorn_stagram/models/photo.dart';
import 'package:unicorn_stagram/providers/likes_provider.dart';
import 'package:unicorn_stagram/providers/theme_provider.dart'; // NOUVEL IMPORT pour le thème !

// Cette classe 'DetailsModal' est mon widget StatefulWidget.
// Un StatefulWidget, c'est comme un terminal de mission interactive dans Mass Effect :
// il peut changer d'état, afficher des informations dynamiques et réagir aux actions de l'utilisateur.
// Ici, c'est la fenêtre pop-up qui apparaît quand on clique sur une photo pour voir ses détails.
class DetailsModal extends StatefulWidget {
  // Je définis ici la 'post' (la photo) que cette modale va afficher.
  // C'est la donnée principale, l'objet de notre attention, comme un rapport de renseignement crucial !
  final Photo post;

  // Le constructeur de ma modale. Je m'assure qu'on me fournisse bien la 'post' requise.
  // Le 'super.key' est juste un détail technique pour Flutter, comme les codes d'authentification pour le terminal.
  const DetailsModal({super.key, required this.post});

  @override
  // Cette méthode crée l'état associé à ce widget.
  // C'est un peu comme si le terminal activait son interface utilisateur interne.
  State<DetailsModal> createState() => _DetailsModalState();
}

// C'est la classe '_DetailsModalState' qui gère l'état interne de ma modale, c'est là que toute l'action se passe !
// C'est ici que je vais stocker les commentaires et gérer la logique d'interaction.
class _DetailsModalState extends State<DetailsModal> {
  // Cette liste privée '_comments' va stocker tous les commentaires que les utilisateurs écrivent.
  // C'est mon journal de bord des observations pour cette photo spécifique.
  final List<String> _comments = [];
  // Le '_commentController' est un outil essentiel pour mon champ de texte où l'utilisateur va taper son commentaire.
  // Il me permet de récupérer ce qui est écrit et de vider le champ après envoi.
  // C'est comme le clavier du terminal pour saisir des données !
  final TextEditingController _commentController = TextEditingController();

  // Cette fonction '_publishComment' est appelée quand l'utilisateur veut envoyer son commentaire.
  // C'est l'action "envoyer le message" !
  void _publishComment() {
    // Je vérifie d'abord si le champ de commentaire n'est pas vide.
    // Pas de messages vides, il faut que ce soit concret, comme un rapport de situation !
    if (_commentController.text.isNotEmpty) {
      // Si c'est bon, j'utilise 'setState' pour indiquer à Flutter que l'état de mon widget va changer.
      // C'est ce qui va faire en sorte que les nouveaux commentaires apparaissent à l'écran.
      // C'est comme mettre à jour le statut de la mission en temps réel.
      setState(() {
        // J'ajoute le texte du commentaire à ma liste.
        _comments.add(_commentController.text);
        // Je vide le champ de texte pour que l'utilisateur puisse en écrire un autre.
        _commentController.clear();
        // Et je retire le focus du champ de texte pour masquer le clavier.
        // C'est comme fermer le panneau de saisie après avoir envoyé le message.
        FocusScope.of(context).unfocus();
      });
    }
  }

  @override
  // La méthode 'dispose()' est très importante ! Elle est appelée quand le widget n'est plus utilisé et va être retiré de l'arbre des widgets.
  // Je l'utilise pour me débarrasser proprement de mon '_commentController'.
  // C'est comme désactiver un système du Normandy pour libérer des ressources quand il n'est plus nécessaire.
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  // La méthode 'build' est le cœur de l'interface utilisateur. C'est ici que je construis l'apparence de ma modale.
  // C'est comme la carte architecturale d'une zone sur une planète.
  Widget build(BuildContext context) {
    // Je récupère l'état du thème pour adapter les couleurs.
    // Le terminal adapte ses couleurs à l'environnement.
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Je définis quelques couleurs pour le thème de mon application, inspirées des couleurs de l'arc-en-ciel d'une licorne.
    // C'est ma palette de couleurs personnalisée, comme le choix des teintes pour l'armure de Shepard !
    final Color unicornPink = isDarkMode ? Colors.pink.shade300 : Colors.pink.shade200;
    final Color unicornPurple = isDarkMode ? Colors.purple.shade300 : Colors.purple.shade200;

    // Je commence par un 'Container' qui va définir la taille et la forme générale de ma modale.
    // Je lui donne 90% de la hauteur de l'écran pour qu'il prenne une bonne place.
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      // J'ajoute une belle décoration avec un fond blanc et des bords arrondis en haut,
      // pour que ça ait l'air "propre" et moderne.
      // C'est comme le design épuré des interfaces de la Citadelle.
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white, // Adapte la couleur de fond
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      // Le 'ClipRRect' me permet de m'assurer que tout le contenu à l'intérieur respecte ces bords arrondis.
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        // J'organise mon contenu en une colonne, du haut vers le bas.
        // C'est une structure logique, comme l'agencement d'un pont de vaisseau.
        child: Column(
          children: [
            // C'est le petit "grippy" en haut, la poignée pour indiquer qu'on peut faire glisser la modale.
            // Une petite barre grise discrète.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, // Adapte la couleur du grippy
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // L''Expanded' et 'SingleChildScrollView' permettent au contenu de la modale de défiler si elle est trop grande.
            // C'est essentiel pour que l'utilisateur puisse voir toutes les informations, même sur de petits écrans.
            // Comme un long rapport de mission qu'on peut faire défiler sur son datapad.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // C'est ici que j'affiche l'image de la photo elle-même.
                    // J'utilise 'ClipRRect' pour lui donner des coins arrondis, c'est plus joli !
                    // Et 'CachedNetworkImage' est super, elle télécharge l'image depuis internet et la met en cache
                    // pour qu'elle s'affiche rapidement les prochaines fois. C'est comme les scans de planètes qui se chargent vite.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16), // Un peu d'espace.
                    // J'affiche la description de la photo. Le texte est centré et stylisé pour être bien visible.
                    // C'est le résumé de l'observation.
                    Text(
                      widget.post.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black), // Adapte la couleur du texte
                    ),
                    const SizedBox(height: 4), // Encore un peu d'espace.
                    // J'affiche le nom de l'auteur, aussi centré mais avec un style plus discret.
                    // "Par ${widget.post.author}", c'est clair et concis.
                    Text(
                      'Par ${widget.post.author}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey, // Adapte la couleur du texte
                          fontSize: 14),
                    ),
                    const SizedBox(height: 16), // Et encore de l'espace.
                    // Ici, j'utilise un 'Consumer' de 'Provider' pour interagir avec mon 'LikesProvider'.
                    // C'est une façon élégante de dire : "Écoute les changements dans les likes et mets-toi à jour !"
                    // C'est comme le système de communication qui met à jour les informations en temps réel sur le Normandy.
                    Consumer<LikesProvider>(
                      builder: (context, likesProvider, child) {
                        // Je vérifie si la photo actuelle est "likée" ou non.
                        final isLiked =
                            likesProvider.isPostLiked(widget.post.id);
                        // J'affiche un bouton 'TextButton.icon'.
                        // Son icône (cœur) et son texte ("J'adore !" ou "Liker") changent en fonction de si la photo est aimée ou non.
                        // Les couleurs sont aussi dynamiques !
                        return TextButton.icon(
                          onPressed: () {
                            // Quand on clique, j'appelle la fonction 'toggleLike' de mon 'likesProvider'.
                            // C'est l'action principale pour aimer ou désaimer la photo.
                            likesProvider.toggleLike(widget.post.id);
                          },
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border, // Cœur plein ou vide.
                            color: isLiked ? Colors.redAccent : unicornPink, // Rouge si aimé, rose si non.
                          ),
                          label: Text(
                            isLiked ? "J'adore !" : "Liker", // Texte approprié.
                            style: TextStyle(
                                color:
                                    isLiked ? Colors.redAccent : unicornPink),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 30), // Une ligne de séparation pour organiser le contenu.
                    // Le titre de la section des commentaires.
                    Text(
                      "Commentaires",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black), // Adapte la couleur du titre
                    ),
                    const SizedBox(height: 8), // Petit espace.
                    // Je vérifie si la liste de commentaires est vide.
                    // Si oui, j'affiche un message pour dire qu'il n'y a pas encore de commentaires.
                    // C'est comme dire "Aucun rapport trouvé" si les données manquent.
                    if (_comments.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text("Aucun commentaire pour le moment.",
                              style: TextStyle(color: isDarkMode ? Colors.grey.shade500 : Colors.grey)), // Adapte la couleur du texte
                        ),
                      )
                    else
                      // Sinon, je parcours ma liste '_comments' et pour chaque commentaire,
                      // je crée un 'ListTile' qui l'affiche.
                      // Chaque commentaire a une petite icône de personne et le texte du commentaire.
                      // C'est ma façon de lister les entrées de journal de bord.
                      ..._comments.map((comment) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: unicornPurple, // Un joli cercle violet.
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 18), // Une icône de personne blanche.
                            ),
                            title: Text(
                              comment,
                              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87), // Adapte la couleur du commentaire
                            ),
                          )),
                  ],
                ),
              ),
            ),
            // Cette section gère le champ de texte pour ajouter de nouveaux commentaires.
            // Elle est placée en bas de la modale.
            Padding(
              // J'utilise 'MediaQuery.of(context).viewInsets.bottom' pour ajuster le padding
              // quand le clavier apparaît, ça pousse le champ de texte vers le haut pour qu'il soit visible.
              // C'est comme ajuster l'interface du Mako quand on est en terrain accidenté !
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16),
              child: Row(
                children: [
                  // Le champ de texte où on tape le commentaire. Il prend la majeure partie de l'espace.
                  Expanded(
                    child: TextField(
                      controller: _commentController, // Associé à mon contrôleur.
                      onSubmitted: (_) => _publishComment(), // Publie le commentaire quand on appuie sur Entrée.
                      decoration: InputDecoration(
                        hintText: "Ajouter un commentaire...", // Le texte indicatif.
                        hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade500 : Colors.grey), // Adapte la couleur du texte d'aide
                        filled: true, // Fond rempli.
                        fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100, // Adapte la couleur de fond
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Bords très arrondis.
                          borderSide: BorderSide.none, // Pas de bordure visible.
                        ),
                      ),
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adapte la couleur du texte saisi
                    ),
                  ),
                  const SizedBox(width: 8), // Un petit espace entre le champ et le bouton.
                  // Le bouton d'envoi. C'est l'icône de l'avion en papier.
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: unicornPurple, // Couleur de fond violette.
                      foregroundColor: Colors.white, // Icône blanche.
                    ),
                    icon: const Icon(Icons.send), // L'icône d'envoi.
                    onPressed: _publishComment, // Appelle ma fonction pour publier le commentaire.
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}