// lib/main.dart

// J'importe tous les outils essentiels de Flutter.
// C'est comme assembler tous les systèmes vitaux du Normandy.
import 'package:flutter/material.dart';
// J'importe ce paquet pour charger mes variables d'environnement, comme ma clé d'API.
// C'est pour accéder aux données sécurisées, comme les codes d'accès N7.
import 'package:flutter_dotenv/flutter_dotenv.dart';
// J'importe le paquet pour utiliser des polices Google.
// Ça donne un style unique aux interfaces, comme les polices spéciales de l'Alliance.
import 'package:google_fonts/google_fonts.dart';
// J'importe le paquet Provider, mon système de gestion d'état préféré.
// C'est le réseau de communication qui relie tous les modules du vaisseau.
import 'package:provider/provider.dart';

// J'importe mes propres "providers" et écrans.
// Mes modules spécialisés pour le Normandy !
import 'package:unicorn_stagram/providers/likes_provider.dart'; // Gère les "j'aime"
import 'package:unicorn_stagram/providers/display_mode_provider.dart'; // NOUVEAU ! Gère le mode grille/colonne
import 'package:unicorn_stagram/providers/theme_provider.dart'; //Gère le thème clair/sombre
import 'package:unicorn_stagram/screens/home_screen.dart'; // Mon écran principal


// C'est la fonction qui lance toute l'application. Elle est le point de départ de l'aventure !
// Elle est "async" car elle doit attendre que le fichier .env soit chargé.
// C'est comme le compte à rebours avant le décollage du Normandy.
Future<void> main() async {
  // Je m'assure que Flutter est complètement initialisé avant de faire quoi que ce soit d'autre.
  // C'est la vérification pré-vol de tous les systèmes.
  WidgetsFlutterBinding.ensureInitialized();
  // Je charge mes variables d'environnement (ma clé d'API, etc.) depuis le fichier .env.
  // Ces données sont cruciales pour la connexion aux services externes, comme les protocoles de cryptage.
  await dotenv.load(fileName: ".env");

  // On lance l'application.
  runApp(
    // J'utilise MultiProvider pour rendre plusieurs de mes gestionnaires d'état (providers)
    // accessibles partout dans l'application.
    // C'est comme le système nerveux central du Normandy, connectant tous les sous-systèmes critiques.
    MultiProvider(
      providers: [
        // Mon LikesProvider s'occupe de l'état des "likes" sur les photos.
        // Il garde une trace de ce que l'équipage "aime".
        ChangeNotifierProvider(create: (context) => LikesProvider()),
        // Mon nouveau DisplayModeProvider gère le choix entre la vue grille et la vue colonne pour les images.
        // C'est le panneau de contrôle pour changer l'affichage tactique du pont.
        ChangeNotifierProvider(create: (context) => DisplayModeProvider()),
        // Et mon ThemeProvider gère le thème clair ou sombre de l'application.
        // C'est le réglage d'éclairage du vaisseau, passant du mode jour au mode nuit furtif.
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      // J'enveloppe mon 'MyApp' dans un 'Consumer<ThemeProvider>' pour que l'application entière
      // puisse réagir aux changements de thème et se redessiner en conséquence.
      // C'est l'interface principale qui s'adapte à la lumière ambiante de l'espace.
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // MaterialApp est le widget qui configure l'application entière (titre, thèmes, navigation).
          // C'est le système d'exploitation global du Normandy.
          return MaterialApp(
            title: 'Unicorn_stagram',
            // J'enlève la petite bannière "Debug" pour une expérience utilisateur plus propre.
            // Pas de messages d'erreur intrusifs sur le HUD du pilote !
            debugShowCheckedModeBanner: false,
            // Je définis le thème CLAIR de mon application.
            // C'est le mode d'éclairage standard, lumineux et coloré.
            theme: ThemeData(
              // Je choisis mes couleurs principales. Le rose et le violet, mes couleurs "Licorne" !
              // Comme les couleurs de l'interface des Terminaux N7.
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.pinkAccent,
                brightness: Brightness.light,
                primary: Colors.pink.shade200,
                secondary: Colors.purple.shade200,
              ),
              // Je personnalise les polices d'écriture avec Google Fonts (Lato et Pacifico).
              // Pour un look unique et lisible, comme les caractères spéciaux des interfaces du Codex.
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ).copyWith(
                headlineSmall: GoogleFonts.pacifico(fontSize: 22), // Pour les titres plus petits.
                bodyMedium: const TextStyle(fontSize: 15), // Pour le texte courant.
                bodySmall: TextStyle( // Pour le texte plus petit et les détails.
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700),
              ),
              // Je personnalise l'apparence de la barre de titre (AppBar).
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white, // Fond blanc.
                foregroundColor: Colors.black87, // Texte noir.
                elevation: 0.5, // Une légère ombre pour la faire ressortir.
                centerTitle: true, // Le titre au centre.
                titleTextStyle: GoogleFonts.pacifico(fontSize: 24, color: Colors.pink.shade300), // Style spécifique pour le titre.
                iconTheme: IconThemeData(color: Colors.purple.shade700), // Couleur des icônes dans l'AppBar
              ),
              scaffoldBackgroundColor: Colors.white, // Fond de l'écran.
              cardColor: Colors.white, // Couleur des cartes.
              useMaterial3: true, // J'active Material Design 3 pour les dernières fonctionnalités visuelles.
            ),
            // Je définis le thème SOMBRE de mon application.
            // C'est le mode furtif, idéal pour naviguer dans l'obscurité de l'espace.
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple, // Une base de couleur plus foncée pour le sombre.
                brightness: Brightness.dark,
                primary: Colors.deepPurple.shade300,
                secondary: Colors.purple.shade300,
              ),
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ).copyWith(
                headlineSmall: GoogleFonts.pacifico(fontSize: 22, color: Colors.white),
                bodyMedium: const TextStyle(fontSize: 15, color: Colors.white70),
                bodySmall: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey.shade900, // Fond très sombre.
                foregroundColor: Colors.white, // Texte blanc.
                elevation: 0.5,
                centerTitle: true,
                titleTextStyle: GoogleFonts.pacifico(fontSize: 24, color: Colors.pink.shade300),
                iconTheme: const IconThemeData(color: Colors.white), // Icônes blanches pour le thème sombre
              ),
              scaffoldBackgroundColor: Colors.grey.shade900, // Fond de l'écran sombre.
              cardColor: Colors.grey.shade800, // Couleur des cartes plus foncée.
              useMaterial3: true,
            ),
            // Enfin, je dis à mon MaterialApp d'utiliser le thème actuel stocké dans mon ThemeProvider.
            // C'est ce qui permet à l'application de basculer dynamiquement entre clair et sombre.
            // Le Normandy adapte son éclairage en fonction du mode de combat ou de repos !
            themeMode: themeProvider.themeMode,
            // On dit à l'application quelle page afficher au démarrage.
            // C'est là où commence l'aventure, sur l'écran d'accueil du Normandy.
            home: const HomeScreen(),
          );
        },
      ),
    ),
  );
}