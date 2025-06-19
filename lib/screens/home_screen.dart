// lib/screens/home_screen.dart

// J'importe tous les modules nécessaires pour mon pont de commande !
import 'package:flutter/material.dart'; // Les fondations pour construire l'interface.
import 'package:cached_network_image/cached_network_image.dart'; // Pour des images du réseau rapides comme l'éclair et mises en cache.
import 'package:provider/provider.dart'; // Mon système de communication interne pour partager l'état.
import 'package:unicorn_stagram/models/photo.dart'; // Mon plan de données pour chaque photo.
import 'package:unicorn_stagram/providers/likes_provider.dart'; // Mon registre des "J'aime" de l'équipage.
import 'package:unicorn_stagram/services/photo_service.dart'; // Mon unité de renseignement pour récupérer les photos.
import 'package:unicorn_stagram/widgets/details_modal.dart'; // Le terminal d'inspection des photos.
import 'package:unicorn_stagram/providers/display_mode_provider.dart'; // Mon panneau de contrôle pour la vue tactique (grille/colonne).
import 'package:unicorn_stagram/providers/theme_provider.dart'; // Le système de réglage d'éclairage du vaisseau (clair/sombre).

// Cette classe 'HomeScreen' est mon widget StatefulWidget principal.
// C'est la console centrale de navigation, capable de réagir aux ordres et aux informations.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Le constructeur, simple et direct.

  @override
  // Cette méthode crée l'état qui sera géré par ce widget.
  // C'est comme initialiser les systèmes opérationnels du pont.
  State<HomeScreen> createState() => _HomeScreenState();
}

// C'est la classe '_HomeScreenState' qui gère tout l'état dynamique et la logique de l'écran d'accueil.
// C'est l'intelligence derrière la console de navigation.
class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Photo>> _postsFuture; // Ce Future va contenir la promesse des photos à venir.
                                          // C'est une mission de récupération de données en attente.
  final PhotoService photoService = PhotoService(); // Mon service de récupération de photos, prêt à l'action.

  @override
  // `initState()` est le premier ordre de mission donné à l'écran.
  // Il est appelé une seule fois quand le pont de commande est activé.
  void initState() {
    super.initState();
    _postsFuture = photoService.findAll(); // Je lance ma mission principale : trouver toutes les photos !
  }

  @override
  // La méthode `build` est le cœur de l'affichage. Elle dessine l'interface de mon pont de commande.
  Widget build(BuildContext context) {
    // Je "veille" sur le DisplayModeProvider pour savoir quel mode d'affichage est actif.
    // C'est comme le système de cartographie qui s'adapte à la vue demandée (planète entière ou zone détaillée).
    final displayModeProvider = Provider.of<DisplayModeProvider>(context);
    final isGridMode = displayModeProvider.currentMode == DisplayMode.grid;

    // Je "veille" aussi sur le ThemeProvider pour savoir si je suis en mode clair ou sombre.
    // C'est le capteur de lumière ambiante du pont, pour ajuster l'éclairage des écrans.
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      // Le `Scaffold` est la structure de base de mon écran, un peu comme le châssis de mon terminal.
      appBar: AppBar(
        title: const Text('Unicorn_stagram 🦄'), // Le titre de mon application, clair et visible.
        actions: [
          // Mon bouton pour basculer entre la vue colonne et la vue grille.
          // C'est l'interrupteur "vue tactique" de la carte de la galaxie.
          IconButton(
            icon: Icon(isGridMode ? Icons.view_column : Icons.grid_on), // L'icône change pour indiquer le mode actuel.
            onPressed: () {
              displayModeProvider.toggleDisplayMode(); // Quand on appuie, je change le mode d'affichage via mon provider.
            },
          ),
          // Mon bouton pour basculer entre le thème clair et le thème sombre.
          // C'est le bouton "mode nuit" sur le pont du vaisseau, pour économiser l'énergie ou s'adapter à l'environnement.
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round), // L'icône change : soleil pour clair, lune pour sombre.
            onPressed: () {
              themeProvider.toggleTheme(); // Quand on appuie, je bascule le thème via mon provider.
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Photo>>(
        // Ce widget attend le résultat de ma mission de récupération de photos (_postsFuture).
        // Il gère les différents états : chargement, erreur, ou données prêtes.
        future: _postsFuture,
        builder: (context, snapshot) {
          // Si la connexion est en attente, j'affiche un indicateur de chargement.
          // Le vaisseau est en phase de synchronisation des données !
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si une erreur est survenue pendant la mission de récupération.
          // Alerte rouge ! Un problème de communication avec l'API !
          if (snapshot.hasError) {
            return Center(
                child: Text('Oups, une erreur est survenue: ${snapshot.error}'));
          }
          // Si les données sont bien arrivées ! Mission accomplie !
          if (snapshot.hasData) {
            final posts = snapshot.data!; // Je récupère la liste des photos.

            // Maintenant, je décide si j'affiche en mode grille ou en mode colonne.
            // C'est ma décision tactique basée sur le réglage du DisplayModeProvider.
            if (isGridMode) {
              // Mode Grille : J'affiche toutes les photos dans une grille compacte.
              // C'est comme une vue d'ensemble rapide de toutes les cibles potentielles.
              return GridView.builder(
                padding: const EdgeInsets.all(2.0), // Un petit espacement autour de la grille.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Je veux 5 photos par ligne pour une bonne densité visuelle.
                  crossAxisSpacing: 2.0, // Espacement horizontal entre les images.
                  mainAxisSpacing: 2.0, // Espacement vertical entre les images.
                ),
                itemCount: posts.length, // Je dis combien de photos il y a au total.
                itemBuilder: (context, index) {
                  final post = posts[index]; // Je prends la photo actuelle.

                  return GestureDetector(
                    onTap: () {
                      // Quand je tape sur une image en mode grille, j'ouvre la modale de détails.
                      // C'est comme cliquer sur un rapport pour avoir toutes les infos détaillées.
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // La modale peut prendre presque toute la hauteur de l'écran.
                        backgroundColor: Colors.transparent, // Pour un effet visuel sympa.
                        builder: (modalContext) {
                          // TRÈS IMPORTANT ICI !
                          // Je dois m'assurer que la modale (qui est un nouvel arbre de widgets)
                          // puisse trouver le LikesProvider. J'utilise donc le `modalContext`
                          // qui est le bon contexte pour la modale elle-même.
                          // C'est comme s'assurer que le terminal de la soute peut toujours
                          // accéder au système de logs principal.
                          return ChangeNotifierProvider.value(
                            value: Provider.of<LikesProvider>(modalContext, listen: false), // Utilisez le bon contexte !
                            child: DetailsModal(post: post), // J'affiche ma modale avec les détails de la photo.
                          );
                        },
                      );
                    },
                    child: CachedNetworkImage( // J'affiche l'image, en la mettant en cache pour la rapidité.
                      imageUrl: post.imageUrl,
                      fit: BoxFit.cover, // L'image remplit l'espace de la case.
                      placeholder: (context, url) => Container( // Ce qui s'affiche pendant le chargement de l'image.
                        color: isDarkMode ? Colors.grey.shade700 : Colors.pink.shade50, // Couleur adaptative au thème.
                      ),
                      errorWidget: (context, url, error) => Container( // Ce qui s'affiche si l'image ne charge pas.
                        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, // Couleur adaptative.
                        child: const Icon(Icons.broken_image, color: Colors.grey), // Icône d'image cassée.
                      ),
                    ),
                  );
                },
              );
            } else {
              // Mode Colonne : J'affiche les photos sous forme de liste verticale, une par une, avec plus de détails.
              // C'est comme un rapport détaillé, avec toutes les informations structurées.
              return ListView.builder(
                padding: const EdgeInsets.all(8.0), // Un espacement autour de la liste.
                itemCount: posts.length, // Le nombre total de photos.
                itemBuilder: (context, index) {
                  final post = posts[index]; // La photo actuelle.
                  return Card( // Chaque photo est dans une "carte" visuelle.
                    color: isDarkMode ? Colors.grey.shade800 : Colors.white, // La couleur de la carte s'adapte au thème.
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    elevation: 4.0, // Une petite ombre pour faire ressortir la carte.
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Bords arrondis.
                    child: GestureDetector(
                      onTap: () {
                        // Quand je tape sur une image en mode colonne, j'ouvre aussi la modale de détails.
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (modalContext) {
                            // ENCORE UNE FOIS, LA CORRECTION ICI !
                            // Je m'assure que la modale trouve bien le LikesProvider avec le bon contexte.
                            return ChangeNotifierProvider.value(
                              value: Provider.of<LikesProvider>(modalContext, listen: false), // Utilisez le bon contexte !
                              child: DetailsModal(post: post),
                            );
                          },
                        );
                      },
                      child: Column( // Les éléments de la carte sont organisés en colonne.
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect( // L'image de la carte, avec des bords arrondis en haut.
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                            child: CachedNetworkImage(
                              imageUrl: post.imageUrl,
                              height: 250, // Une hauteur fixe pour les images en mode colonne.
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 250,
                                color: isDarkMode ? Colors.grey.shade700 : Colors.pink.shade50,
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 250,
                                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                              ),
                            ),
                          ),
                          Padding( // Le contenu texte de la carte, avec un padding.
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text( // La description de la photo.
                                  post.description,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black, // Le texte s'adapte au thème.
                                  ),
                                  maxLines: 2, // Je limite la description à deux lignes.
                                  overflow: TextOverflow.ellipsis, // S'il y a trop de texte, j'ajoute "..."
                                ),
                                const SizedBox(height: 4),
                                Text( // L'auteur de la photo.
                                  'Par ${post.author}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey, // Le texte s'adapte au thème.
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Consumer<LikesProvider>( // Le bouton "J'aime" dans la carte.
                                  builder: (context, likesProvider, child) {
                                    final isLiked = likesProvider.isPostLiked(post.id);
                                    return TextButton.icon(
                                      onPressed: () => likesProvider.toggleLike(post.id),
                                      icon: Icon(
                                        isLiked ? Icons.favorite : Icons.favorite_border,
                                        color: isLiked ? Colors.redAccent : (isDarkMode ? Colors.pink.shade300 : Colors.pink.shade200), // La couleur de l'icône s'adapte au thème.
                                      ),
                                      label: Text(
                                        isLiked ? "J'adore !" : "Liker",
                                        style: TextStyle(
                                          color: isLiked ? Colors.redAccent : (isDarkMode ? Colors.pink.shade300 : Colors.pink.shade200), // La couleur du texte s'adapte au thème.
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          // Si `snapshot.hasData` est faux et qu'il n'y a pas d'erreur, c'est qu'il n'y a pas de photos.
          // Le codex est vide.
          return const Center(child: Text("Aucun post pour le moment."));
        },
      ),
    );
  }
}